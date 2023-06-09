# frozen_string_literal: true

require_relative "lib/bridgetown/deploy_hook/version"

Gem::Specification.new do |spec|
  spec.name = "bridgetown-deploy_hook"
  spec.version = Bridgetown::DeployHook::VERSION
  spec.authors = ["Michael Herold"]
  spec.email = ["opensource@michaeljherold.com"]
  spec.summary = "Add a Bridgetown hook triggered by HTTP for running post-deploy actions"
  spec.description = spec.summary
  spec.homepage = "https://github.com/michaelherold/bridgetown-deploy_hook"
  spec.license = "MIT"

  spec.files = %w[CHANGELOG.md CONTRIBUTING.md LICENSE.md README.md]
  spec.files += %w[bridgetown-deploy_hook.gemspec]
  spec.files += Dir["lib/**/*.rb"]
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 3.0.0"

  spec.add_dependency "bridgetown", ">= 1.2", "< 2.0"
  spec.add_dependency "zeitwerk"

  spec.add_development_dependency "bundler", ">= 2"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/michaelherold/bridgetown-deploy_hook/issues",
    "changelog_uri" => "https://github.com/michaelherold/bridgetown-deploy_hook/blob/main/CHANGELOG.md",
    "documentation_uri" => "https://rubydoc.info/gems/bridgetown-deploy_hook/#{Bridgetown::DeployHook::VERSION}",
    "homepage_uri" => "https://github.com/michaelherold/bridgetown-deploy_hook",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/michaelherold/bridgetown-deploy_hook"
  }
end
