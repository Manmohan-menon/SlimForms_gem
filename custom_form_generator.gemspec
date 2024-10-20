# frozen_string_literal: true

require_relative "lib/custom_form_generator/version"

Gem::Specification.new do |spec|
  spec.name = "custom_form_generator"
  spec.version = CustomFormGenerator::VERSION
  spec.authors = ["manmohan.menon"]
  spec.email = ["manmohan.menon@gmail.com"]

  spec.summary = %q{A custom form generator using Slim and JSON data.}
  spec.description = %q{This gem generates forms based on JSON data, using Slim for templating.}
  spec.homepage = "https://github.com/Manmohan-menon/SlimForms_gem"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://github.com/Manmohan-menon/SlimForms_gem"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Manmohan-menon/SlimForms_gem"
  spec.metadata["changelog_uri"] = "https://github.com/Manmohan-menon/SlimForms_gem"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    Dir['lib/**/*.rb'] + %w(
      README.md
      custom_form_generator.gemspec
    ).reject { |file| file == 'custom_form_generator-0.1.4.gem' }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "slim", "~> 5.0.0"
  spec.add_dependency "json", "~> 2.0.0"
  spec.add_dependency "yaml", "~> 0.1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
