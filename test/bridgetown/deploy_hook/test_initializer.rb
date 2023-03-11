# frozen_string_literal: true

require "test_helper"

module Bridgetown
  module DeployHook
    class TestInitializer < Bridgetown::TestCase
      def setup
        super
        @config = Bridgetown.configuration(
          "root_dir" => root_dir,
          "source" => source_dir,
          "destination" => dest_dir,
          "quiet" => true
        )
        @site = Bridgetown::Site.new(@config)
        maybe_reload_initializer(@config)
      end

      def test_merging_into_preexisting_configuration_prefers_the_preexisting
        with_initializer(<<~RUBY)
          Bridgetown.configure do
            deploy_hook do
              authorization do
                basic ->(_) { true }
                bearer ->(_) { true }
              end
              route "preexisting"
            end

            init "bridgetown-deploy_hook", authorization: {basic: "ignored"}, route: "ignored"
          end
        RUBY

        @config.run_initializers! context: :static

        assert_equal "preexisting", @config.deploy_hook.route
        assert_equal ["basic", "bearer"], @config.deploy_hook.authorization.keys
        assert(
          @config.deploy_hook.authorization.basic.respond_to?(:call),
          "The basic configuration was not ignored"
        )
      end
    end
  end
end
