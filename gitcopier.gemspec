# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gitcopier/version'

Gem::Specification.new do |spec|
  spec.name          = "gitcopier"
  spec.version       = Gitcopier::VERSION
  spec.authors       = ["Victor Tran"]
  spec.email         = ["vu.tran54@gmail.com"]
  spec.summary       = %q{Help developers to integrate between multiple repositories}
  spec.description   = %q{Sometime, you work for a Rails project but its front end is adopted from other repositories (such as separated repository from a front end developer who is not familiar with Rails) and you need to integrate front end changes to the project. You need to see what files were changed, copy them accordingly. This gem will help you do the job really fast.}
  spec.homepage      = "https://github.com/tranvictor/gitcopier"
  spec.license       = "MIT"

  spec.files         = Dir["{lib,bin}/**/*", "LICENSE.txt", "Rakefile", "README.md"]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency "colorize", "~> 0.7"
end
