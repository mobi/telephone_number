# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'telephone_number/version'

Gem::Specification.new do |spec|
  spec.name          = "telephone_number"
  spec.version       = TelephoneNumber::VERSION
  spec.author        = 'MOBI Wireless Management'
  spec.email         = ["adam.fernung@mobiwm.com", "josh.wetzel@mobiwm.com"]
  spec.summary       = 'Phone number validation'
  spec.homepage      = "https://github.com/mobi/telephone_number"
  spec.license       = "MIT"


  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "pry-byebug", "~> 3.4"
end
