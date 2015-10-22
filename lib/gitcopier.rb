require 'colorize'
require "gitcopier/version"
require "gitcopier/decision"
require "gitcopier/decisions"
require "gitcopier/dir_tree"
require "gitcopier/command_line"

module Gitcopier

  INTEGRATION_FILE_NAME = '.gitcopier'

  class Integrator
    def initialize(integrate_path, root_path)
      @root_path = root_path
      @integrate_path = integrate_path
      @decisions = Decisions.new(@root_path, @integrate_path)
      @decisions.load
    end

    # This method get relative path of all changed files to git root
    def changed_files
      commit_log.split("\n").select do |line|
        line.match(/[ACDMRTUXB*]+\t.+/)
      end.map(&:strip)
    end

    def commit_log
      @commit_log ||= raw_git_commit_log
    end

    def copy(source, des)
      # source is a directory, copy its content
      # TODO: create destination if it doesnt exist
      if source.end_with? '/'
        puts "Copy #{(source + '*').colorize(:green)} to #{des.colorize(:green)}."
        FileUtils.mkdir_p(des)
        FileUtils.cp_r(Dir["#{source}*"], des)
      else # source is a file, copy it to destination
        puts "Copy #{source.colorize(:green)} to #{des.colorize(:green)}."
        FileUtils.cp_r(source, des)
      end
    end

    def print_integration_info
      puts "====================================================="
      puts "          Integrating changes to #{@integrate_path}".colorize(:yellow)
      puts "====================================================="
      commit, author, date = commit_log.split("\n")[0..2]
      _, h = commit.split(' ')
      print "Commit: ", h.colorize(:yellow)
      _, a = author.split(': ')
      print "\nAuthor: ", a.colorize(:yellow)
      _, d = date.split(': ')
      print "\nDate: ", d.colorize(:yellow), "\n"
      puts "====================================================="
    end

    def integrate_all_changes
      STDIN.reopen('/dev/tty')
      print_integration_info
      dir_tree = DirTree.new(@root_path, changed_files)
      dir_tree.travel do |changed_file|
        decision = @decisions.get(changed_file)
        just_decided = decision.nil?
        unless decision
          decision = @decisions.prompt_decision(changed_file) unless decision
        end
        if decision.is_copy?
          print "Follow previous decision: " unless just_decided
          copy(@root_path + decision.source, @integrate_path + decision.des)
          next true
        elsif decision.is_follow?
          next nil
        else
          next false
        end
      end
    ensure
      print "\nSaving decisions for later usage...".colorize(:green)
      @decisions.save
      puts "Done.".colorize(:green)
    end

    private
    def raw_git_commit_log
      IO.popen(['git', 'log', '--name-status', '-1']).read
    end
  end
end
