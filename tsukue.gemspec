
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tsukue/version"

Gem::Specification.new do |spec|
  spec.name          = "tsukue"
  spec.version       = Tsukue::VERSION
  spec.authors       = ["cignoir"]
  spec.email         = ["cignoir@gmail.com"]

  spec.summary       = %q{Tsukue}
  spec.description   = %q{A expander of rowspan & colspan for Nokogiri table}
  spec.homepage      = "https://github.com/cignoir/tsukue"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activesupport"
  spec.add_runtime_dependency "nokogiri"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
