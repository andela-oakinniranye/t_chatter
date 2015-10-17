# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 't_chatter/version'

Gem::Specification.new do |spec|
  spec.name          = "t_chatter"
  spec.version       = TChatter::VERSION
  spec.authors       = ["Oreoluwa Akinniranye"]
  spec.email         = ["oreoluwa.akinniranye@andela.com"]

  spec.summary       = %q{Allows you to chat on your terminal}
  spec.description   = %q{TChatter allows you to chat with your friends on your terminal. You can extend it further though to chat your friends on Slack and other applications.}
  spec.homepage      = "http://github.com/andela-oakinniranye/t_chatter"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = ['t_chatter', 'setup_t_chatter']
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday"
  spec.add_dependency "json"


  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
