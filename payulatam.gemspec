# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "payulatam/version"

Gem::Specification.new do |s|
  s.name        = "payulatam"
  s.version     = Payulatam::VERSION
  s.authors     = ["Sebastian Gamboa", "Gustavo Guichard"]
  s.email       = ["me@sagmor.com", "gustavoguichard@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Payulatam}
  s.description = %q{Payulatam}

  s.rubyforge_project = "payulatam"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "hashie"
end
