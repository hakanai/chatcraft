# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "chatcraft/version"

Gem::Specification.new do |s|
  s.name        = "chatcraft"
  s.version     = Chatcraft::VERSION
  s.authors     = ["Trejkaz"]
  s.email       = ["trejkaz@trypticon.org"]
  s.homepage    = ""
  s.summary     = %q{EventMachine-based, multi-protocol chat client}
  s.description = %q{EventMachine-based, multi-protocol chat client. Aiming to support IRC and XMPP with the protocol differences abstracted away so that plugins don't have to know about it.}

  #s.rubyforge_project = "chatcraft"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib', 'plugins']

  # specify any dependencies here; for example:
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'simplecov'

  s.add_runtime_dependency 'eventmachine', '~>1.0'
  s.add_runtime_dependency 'em-irc'
  s.add_runtime_dependency 'blather'
end
