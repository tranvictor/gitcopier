require 'json'
require 'fileutils'
require 'colorize'

module Gitcopier
  class CommandLine
    def self.showall(options)
      integrations = load_integration
      puts "You have #{integrations.size} integration.".colorize(:yellow)
      integrations.each do |int|
        source = int['source'].colorize(:green)
        des = int['des'].colorize(:green)
        puts "Integration from #{source} to #{des}"
      end
    end

    def self.integrate(options)
      integrations = load_integration
      return unless validated_options = validate(options)
      if integration_exist?(integrations, validated_options)
        puts "You already have this integration.".colorize(:yellow)
        return
      end
      integrations << {
        source: validated_options[:from],
        des: validated_options[:to]
      }
      generate_git_callback(
        validated_options[:from],
        validated_options[:to])
    ensure
      save_integrations(integrations)
    end

    def self.integration_exist?(integrations, options)
      integrations.find_index do |integration|
        (integration['source'] == options[:from] &&
         integration['des'] == options[:to])
      end != nil
    end

    def self.generate_git_callback(from, to)
      des = File.join from, ".git", "hooks", "post-merge"
      puts "Generating script to #{des}.".colorize(:green)
      script = <<-SCRIPT
#!/usr/bin/env ruby
#
# This script will ask to copy changed file after the merge
#
# User's decisions on coping the files will be recorded to not to ask next time
# User can reconfigure the decision later by modifing the record
# User can apply a decision on the whole directory
#

require 'gitcopier'

integrator = Gitcopier::Integrator.new(
  "#{to}", "#{from}")
integrator.integrate_all_changes
      SCRIPT
      File.write(des, script)
      FileUtils.chmod "+x", des
      puts "Done."
    end

    # --from and --to options must be both specified
    # --from must be an existing directory and is under git control
    # --to must be an exising directory
    # remove trailing / from --from and --to
    def self.validate(opt)
      options = opt.clone
      if options[:from].nil? || options[:to].nil?
        puts "--from and --to options must be both specified".colorize(:red)
        return nil
      end
      if !under_git_control?(options[:from])
        puts "--from option must be under git control".colorize(:red)
        return nil
      end
      if !exist?(options[:to])
        puts "--to option must be an existing directory".colorize(:red)
      end
      options[:from] = options[:from][0..-2] if options[:from][-1] == "/"
      options[:to] = options[:to][0..-2] if options[:to][-1] == "/"
      return options
    end

    def self.exist?(path)
      File.directory? path
    end

    def self.under_git_control?(path)
      return false unless self.exist?(path)
      pwd = Dir.pwd
      Dir.chdir(path)
      git = IO.popen(['git', 'rev-parse', '--is-inside-work-tree']).read.chomp
      Dir.chdir(pwd)
      return git == "true"
    end

    def self.load_integration
      file_path = File.join(Dir.home, Gitcopier::INTEGRATION_FILE_NAME)
      JSON.parse(File.read(file_path)) rescue []
    end

    def self.save_integrations(integrations)
      file_path = File.join(Dir.home, Gitcopier::INTEGRATION_FILE_NAME)
      File.write(file_path, JSON.pretty_generate(integrations))
    end

    def self.execute(options)
      if options[:command].nil?
        puts "No command specified.".colorize(:red)
        exit(0)
      end
      send(options[:command], options)
    end
  end
end
