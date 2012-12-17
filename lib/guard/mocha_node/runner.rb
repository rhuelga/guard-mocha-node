require 'open3'
require 'guard/ui'

module Guard
  class MochaNode
    module Runner
      def self.run(paths = [], options = {})
        return false if paths.empty?

        @paths   = paths
        @options = options

        print_message
        execute_mocha_node_command
      end

      private

      def self.print_message
        message = @options[:message]
	is_all_specs = @paths.sort == @options[:paths_for_all_specs].sort
        message ||= is_all_specs ? "Running all specs" : "Running: #{@paths.join(' ')}"
        ::Guard::UI.info(message, :reset => true)
      end

      def self.execute_mocha_node_command
        ::Open3.popen3(*mocha_node_command)
      end

      def self.mocha_node_command
        argvs = [ @options[:mocha_bin] ]
        argvs += command_line_options
        argvs += @paths
        argvs.map(&:to_s)
      end

      def self.command_line_options
        options = []

        if @options[:coffeescript]
          options += %w(--compilers coffee:coffee-script)
        end

        if @options[:recursive]
          options << "--recursive"
        end

        if @options[:color]
          options << "-c"
        else
          options << "-C"
        end

        options
      end
    end
  end
end
