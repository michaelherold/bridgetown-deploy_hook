# frozen_string_literal: true

require "test_helper"

if ENV["CI"] || ENV["COVERAGE"]
  SimpleCov.command_name "test:integration"
end

module Bridgetown
  module DeployHook
    class TestIntegration < Bridgetown::TestCase
      include Rack::Test::Methods

      def app
        ENV["RACK_ENV"] = "development"
        @@deploy_hook_app ||= ::Rack::Builder.parse_file(
          File.expand_path("integration/config.ru", __dir__)
        )
      end

      def site
        app.opts[:bridgetown_site]
      end
    end
  end
end
