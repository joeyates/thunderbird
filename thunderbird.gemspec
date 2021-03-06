# frozen_string_literal: true

require_relative "lib/thunderbird/version"

Gem::Specification.new do |spec|
  spec.name = "thunderbird"
  spec.version = Thunderbird::Version::VERSION
  spec.authors = ["Joe Yates"]
  spec.email = ["joe.g.yates@gmail.com"]

  spec.summary = "Conveniences for interacting with Mozilla Thunderbird"
  spec.homepage = "https://github.com/joeyates/thunderbird"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.5"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/joeyates/thunderbird"
  spec.metadata["changelog_uri"] = "https://github.com/joeyates/thunderbird/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = []
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "os"
end
