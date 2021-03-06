# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "uber_config/version"

Gem::Specification.new do |s|
  s.name        = "uber_config"
  s.version     = UberConfig::VERSION
  s.authors     = ["Travis Reeder"]
  s.email       = ["treeder@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Loads configs from common locations.}
  s.description = %q{Loads configs from common locations.}

  s.rubyforge_project = "uber_config"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
