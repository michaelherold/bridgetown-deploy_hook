# frozen_string_literal: true

module Bridgetown
  module DeployHook
    # Handles authorizing a request via its [Authorization header][1]
    #
    # You can configure the authorization strategies via the
    # bridgetown-deploy_hook initializer. For example, if you want to allow a
    # [Bearer token][2], give the configuration a callable at the `:bearer`
    # value in the authorization parameter.
    #
    # @example Allowing a specific Bearer token
    #
    #   Bridgetown.configure do
    #     init(
    #       "bridgetown-deploy_hook",
    #       authorization: {
    #         bearer: ->(token) { token == "myvaluemaybefromtheenvironment" }
    #       }
    #     )
    #   end
    #
    # The webhook handler parses the Authorization header and dispatches the
    # authorization request to the appropriate scheme registered in the
    # configuration. For example, if you want to allow [HTTP Basic
    # authorization][3], the scheme is `Basic` so register the `:basic` or
    # `"basic"` key in the site configuration.
    #
    # The authorization parameters are passed directly without any parsing or
    # conversion so your interpreter will need to be able to convert the raw
    # string appropriately. Missing values will end up with a `nil` so ensure
    # you handle the `nil` case as well.
    #
    # Handlers can be anything that responds to a `#call` of a String or `nil`
    # with a Boolean (or any truthy/falsey combination if that floats your
    # boat).
    #
    # [1]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Authorization
    # [2]: https://datatracker.ietf.org/doc/html/rfc6750
    # [3]: https://datatracker.ietf.org/doc/html/rfc7617
    class Authorization
      # The default authorizer that rejects everything
      #
      # @private
      #
      # @return [#call<String, nil>: Boolean] the authorizer
      REJECT_ALL = ->(*) { false }.freeze

      # Initializes a new {Authorization}
      #
      # @since 0.1.0
      # @api public
      #
      # @example Using the authorizers from the current Bridgetown site
      #
      #   Bridgetown::DeployHook::Authorization.new(
      #     "Basic YmlsYm86dGVzdA==",
      #     config: Bridgetown::Current.site.config.deploy_hook
      #   )
      #
      # @param header [String, nil] the value from the Authorization header
      # @param config [HashWithDotAccess::Hash] the deploy hook configuration
      #   for a `Bridgetown::Site`
      # @return [void]
      def initialize(header, config:)
        scheme, @parameters = header&.split(" ", 2)
        @authorizer = config.authorization.fetch(scheme&.downcase, REJECT_ALL)
      end

      # Authorizes the request based on its Authorization header
      #
      # @since 0.1.0
      # @api public
      #
      # @example Authorizing every Bearer token (don't do this!)
      #
      #   auth = Bridgetown::DeployHook::Authorization.new(
      #     "Bearer 123",
      #     config: HashWithDotAccess::Hash.new(
      #       authorization: {bearer: ->(_) { true }}
      #     )
      #   )
      #   auth.call #=> true
      #
      # @return [Boolean] true when authorized, false otherwise
      def call
        authorizer.call(parameters)
      end

      private

      # The authorizer responsible for checking the header value
      #
      # This can be anything that responds to a `#call` of a String or `nil`
      # with a Boolean.
      #
      # @api private
      # @private
      #
      # @return [#call<String, nil>: Boolean]
      attr_reader :authorizer

      # The parameters extracted from the Authorization header
      #
      # @api private
      # @private
      #
      # @return [String, nil]
      attr_reader :parameters
    end
  end
end
