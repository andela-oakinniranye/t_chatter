# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 't_charter/version'

Gem::Specification.new do |spec|
  spec.name          = "t_charter"
  spec.version       = TCharter::VERSION
  spec.authors       = ["Oreoluwa Akinniranye"]
  spec.email         = ["oreoluwa.akinniranye@andela.com"]

  spec.summary       = %q{Allows you to chat on your terminal}
  spec.description   = %q{TCharter allows you to chat with your friends on your terminal}
  spec.homepage      = "http://github.com/andela-oakinniranye/chatter"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "You know for crap"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = ['t_charter']#spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday"
  # spec.add_dependency "yaml"
  # spec.add_dependency "singleton"
  spec.add_dependency "json"


  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
