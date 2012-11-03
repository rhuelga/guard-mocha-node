# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "guard/mocha_node/version"

Gem::Specification.new do |s|
  s.name        = "guard-mocha-node"
  s.version     = Guard::MochaNodeVersion::VERSION
  s.authors     = ["dave@kapoq.com"]
  s.email       = ["dave@kapoq.com"]
  s.homepage    = "https://github.com/kanzeon/guard-mocha-node"
  s.summary     = %q{Guard::MochaNode automatically runs your Mocha Node specs when files are modified}
  s.description = %q{}

  s.rubyforge_project = "guard-mocha-node"

  s.add_dependency "guard", ">= 0.4"

  s.add_development_dependency "rspec"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "rake"
  if RUBY_PLATFORM =~ /linux/
    s.add_development_dependency "rb-inotify"
    s.add_development_dependency "libnotify"
  end

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
