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
        message ||= @paths == PATHS_FOR_ALL_SPECS ? "Running all specs" : "Running: #{@paths.join(' ')}"
        ::Guard::UI.info(message, :reset => true)
      end

      def self.execute_mocha_node_command
        ::Open3.popen3(mocha_node_command)
      end

      def self.mocha_node_command
        "#{@options[:mocha_bin]} #{command_line_options} #{@paths.join(' ')}"
      end

      def self.command_line_options
        options = []
        options << "--compilers coffee:coffee-script" if @options[:coffeescript]
        options << "--recursive" if @options[:recursive]
	if @options[:color]
	  options << "-c"
	else
	  options << "-C"
	end
        options.join(" ")
      end
    end
  end
end
