require 'json'
require 'readline'
require 'gitcopier/decision'

module Gitcopier
  class Decisions
    def initialize(source_root, des_root)
      @source_root = source_root
      @des_root = des_root
    end

    def load
      @data = JSON.parse(get_data_from_file)
      @decisions = Hash[@data.map do |pair|
        source = pair[0]

        decision = Decision.new(
          pair[1]['decision'], pair[1]['source'], pair[1]['des'])

        [source, decision]
      end]
    end

    def save
      File.write(decision_file, JSON.pretty_generate(@decisions))
    end

    def get(changed_file)
      @decisions[changed_file]
    end

    def get_data_from_file
      File.read(decision_file) rescue "{}"
    end

    def prompt_decision(changed_file)
      source_file = @source_root + changed_file
      source_file << "*" if source_file[-1] == "/"
      while true do
        print "Where do you want to copy #{(@source_root + changed_file).colorize(:green)}? (type h for instruction): "
        user_input = Readline.readline("", true).strip
        if user_input == "h"
          puts "      #{'h'.colorize(:green)}: For instructions"
          puts "      #{'n'.colorize(:green)}: For not copy the file or directory recursively"
          puts "#{'<enter>'.colorize(:green)}: If it's a file, it will ignore the file. If it's a directory, it will prompt you to decide on files/directories inside recursively"
          puts " #{'<path>'.colorize(:green)}: It will copy the file or directory's content to the path."
        elsif user_input == "n"
          decision = Decision.new("n", changed_file, "")
          @decisions[changed_file] = decision
          return decision
        elsif user_input == ""
          decision = Decision.new("", changed_file, "")
          @decisions[changed_file] = decision
          return decision
        else
          unless is_valid?(user_input)
            next
          end
          destination = user_input[@des_root.size..user_input.size]
          decision = Decision.new("y", changed_file, destination)
          @decisions[changed_file] = decision
          return decision
        end
      end
    end

    def is_valid?(des_string)
      if !des_string.start_with? @des_root
        puts "Your path must be inside #{@des_root}".colorize(:red)
        # TODO: support user to reconfigure destination root
        return false
      end
      true
    end

    private
    def decision_file
      File.join(@des_root, '.gitcopier_decisions.json')
    end
  end
end
