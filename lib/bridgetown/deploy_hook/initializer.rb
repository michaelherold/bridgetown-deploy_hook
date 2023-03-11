# frozen_string_literal: true

# @param config [HashWithDotAccess::Hash] the configuration for the Bridgetown site
# @param authorization [Hash<(Symbol, String, nil), #call<String, nil>: Boolean>] a
#   Hash mapping Authorization schemes to authenticators, callables that map
#   string-encoded parameters to Boolean values to indicate whether the attempt
#   was a success or failure
# @param route [String] the route for the deploy hook within the Roda application
Bridgetown.initializer "bridgetown-deploy_hook" do |config, authorization: {}, route: "_bridgetown/deploy"|
  options = {authorization: authorization, route: route}

  # :nocov: Because it's not possible to show coverage for both branches
  if config.deploy_hook
    config.deploy_hook Bridgetown::Utils.deep_merge_hashes(options, config.deploy_hook)
  else
    config.deploy_hook(options)
  end
  # :nocov:
end
