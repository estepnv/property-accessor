require_relative 'lib/property_accessor/version'

Gem::Specification.new do |spec|
  spec.name          = "property-accessor"
  spec.version       = PropertyAccessor::VERSION
  spec.authors       = ["Evgeny Stepanov"]
  spec.email         = ["estepnv@icloud.com"]

  spec.summary       = "Ruby syntax sugar for C# style property accessor definition"
  spec.homepage      = "https://github.com/estepnv/property-accessor"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/estepnv/property-accessor"
  spec.metadata["changelog_uri"] = "https://github.com/estepnv/property-accessor"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{(test|spec|features|git|rspec|travis)/}) }
  end

  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
