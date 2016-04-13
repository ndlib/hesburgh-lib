# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hesburgh/lib/version'

Gem::Specification.new do |spec|
  spec.name          = "hesburgh-lib"
  spec.version       = Hesburgh::Lib::VERSION
  spec.authors       = ["Jeremy Friesen"]
  spec.email         = ["jeremy.n.friesen@gmail.com"]
  spec.summary       = %q{A toolbox of code that may be reusable.}
  spec.description   = %q{A toolbox of code that may be reusable.}
  spec.homepage      = "https://github.com/ndlib/hesburgh-lib"
  spec.license       = "APACHE2"

  spec.files         = `git ls-files -z -- bin/* lib/* LICENSE README.md hesburgh-lib.gemspec`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'loofah', "~> 2.0.3"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec-given", "~> 3.5"
  spec.add_development_dependency "rubocop", "~> 0.27"
  spec.add_development_dependency "activesupport", ">= 3.0"
end
