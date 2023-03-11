# frozen_string_literal: true

require "test_helper"

if ENV["CI"] || ENV["COVERAGE"]
  SimpleCov.command_name "test:integration"
end

module Bridgetown
  module DeployHook
    class TestIntegration < Bridgetown::TestCase
      include Rack::Test::Methods

      def setup
        super
        site.config.delete(:post_deploy_ran_at)
      end

      def test_authorized_requests
        webhook "Bearer Ilikelessthanhalfofyouhalfaswellasyoudeserve"

        assert last_response.ok?, "Response was #{last_response.status}, not 200 OK"
        assert_equal "success", last_response.body.then { |b| JSON.parse(b) }["status"]
      end

      def test_authorized_head_requests
        head_check "Bearer Ilikelessthanhalfofyouhalfaswellasyoudeserve"

        assert last_response.ok?, "Response was #{last_response.status}, not 200 OK"
        assert_empty last_response.body
      end

      def test_malformed_authorization_header
        webhook ""

        assert last_response.unauthorized?, "Response was #{last_response.status}, not 403 Unauthorized"
        assert_equal "unauthorized", last_response.body.then { |b| JSON.parse(b) }["error"]
      end

      def test_unauthorized_requests
        webhook "Bearer IdontknowhalfofyouhalfaswellasIshouldlike"

        assert last_response.unauthorized?, "Response was #{last_response.status}, not 403 Unauthorized"
        assert_equal "unauthorized", last_response.body.then { |b| JSON.parse(b) }["error"]
      end

      def test_authorization_by_unknown_credential_type
        webhook "Basic YmlsYm86dGVzdA=="

        assert last_response.unauthorized?, "Response was #{last_response.status}, not 403 Unauthorized"
        assert_equal "unauthorized", last_response.body.then { |b| JSON.parse(b) }["error"]
      end

      def test_unauthorized_head_requests
        head_check

        assert last_response.unauthorized?, "Response was #{last_response.status}, not 403 Unauthorized"
        assert_empty last_response.body
      end

      private

      def head_check(auth = nil)
        head "/_deploy", {}, {"HTTP_AUTHORIZATION" => auth}.compact
      end

      def options_check(auth = nil)
        options "/_deploy", {}, {"HTTP_AUTHORIZATION" => auth}.compact
      end

      def webhook(auth)
        get "/_deploy", {}, {"HTTP_AUTHORIZATION" => auth}
      end

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
