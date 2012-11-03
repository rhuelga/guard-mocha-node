require 'guard/mocha_node'

Guard::Mochanode = Guard::MochaNode

module Guard
  class Mochanode < Guard
    GEM_NAME = "mocha-node"

    # Guardfile template needed inside guard gem
    def self.init(name)
      if ::Guard::Dsl.guardfile_include?(GEM_NAME)
        ::Guard::UI.info "Guardfile already includes #{GEM_NAME} guard"
      else
        content = File.read('Guardfile')
        guard   = File.read("#{::Guard.locate_guard(GEM_NAME)}/lib/guard/mocha_node/templates/Guardfile")
        File.open('Guardfile', 'wb') do |f|
          f.puts(content)
          f.puts("")
          f.puts(guard)
        end
        ::Guard::UI.info "#{name} guard added to Guardfile, feel free to edit it"
      end
    end
  end
end
