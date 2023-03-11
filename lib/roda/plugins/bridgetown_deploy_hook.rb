# frozen_string_literal: true

# A routing tree for building Rack applications
#
# @see https://roda.jeremyevans.net/
class Roda
  # The namespace Roda uses for loading plugins by convention
  module RodaPlugins
    # A plugin that integrates a post-deploy webhook into a Bridgetown Roda app
    #
    # This plugin requires the Bridgetown SSR plugin to be enabled before it.
    #
    # It creates a route via the configuration set in the initializer that
    # authorizes requests via {Bridgetown::DeployHook::Authorization} and runs
    # the post deploy hook when authorized.
    #
    # See {Bridgetown::DeployHook} for an example of adding a post-deploy hook.
    #
    # See {Bridgetown::DeployHook::Authorization} for more information about
    # authorization strategies.
    module BridgetownDeployHook
      # The string representing an empty response body
      #
      # @api private
      # @private
      EMPTY_BODY = ""

      # The Roda hook for configuring the plugin
      #
      # @since 0.1.0
      # @api public
      #
      # @example Adding the plugin to your Bridgetown Roda app
      #
      #    class RodaApp < Bridgetown::Rack::Roda
      #      plugin :bridgetown_ssr
      #      plugin :bridgetown_deploy_hook
      #    end
      #
      # @param app [::Roda] the Roda application to configure
      # @return [void]
      def self.configure(app)
        return unless app.opts[:bridgetown_site].nil?

        # :nocov: Because it's difficult to set up multiple contexts
        raise(
          "Roda app failure: the bridgetown_ssr plugin must be registered before " \
          "bridgetown_deploy_hook"
        )
        # :nocov:
      end

      # Methods included in to the Roda request
      #
      # @see http://roda.jeremyevans.net/rdoc/classes/Roda/RodaPlugins/Base/RequestMethods.html
      module RequestMethods
        # Builds the deploy hook route within the Roda application
        #
        # @since 0.1.0
        # @api public
        #
        # @example Enabling the deploy hook route
        #
        #   class RodaApp < Bridgetown::Rack::Roda
        #     plugin :bridgetown_ssr
        #     plugin :bridgetown_deploy_hook
        #
        #     route do |r|
        #       r.bridgetown_deploy_hook
        #     end
        #   end
        #
        # @return [void]
        def bridgetown_deploy_hook
          site = roda_class.opts[:bridgetown_site]
          config = site.config.deploy_hook

          on(config.route) do
            is do
              authorization = Bridgetown::DeployHook::Authorization.new(
                env["HTTP_AUTHORIZATION"],
                config: config
              )

              response["Content-Type"] = "application/json"

              if (authorized = authorization.call)
                response.status = 200
                response.write('{"status":"success"}')
              else
                response["WWW-Authenticate"] = config.authorization.keys
                response.status = 401

                response.write('{"status":"error","error":"unauthorized"}')
              end

              get do
                Bridgetown::Hooks.trigger(:site, :post_deploy, site) if authorized

                halt response.finish
              end

              head do
                response.finish # to properly set the Content-Length header
                halt response.finish_with_body(EMPTY_BODY)
              end
            end
          end
        end
      end
    end

    register_plugin :bridgetown_deploy_hook, BridgetownDeployHook
  end
end
