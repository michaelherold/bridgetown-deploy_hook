# frozen_string_literal: true

require "bridgetown-deploy_hook"

Bridgetown.configure do |config|
  url "https://bagend.com"

  init(
    "bridgetown-deploy_hook",
    authorization: {
      bearer: ->(token) { token == "Ilikelessthanhalfofyouhalfaswellasyoudeserve" }
    },
    route: "_deploy"
  )
end

Bridgetown::Hooks.register_one :site, :post_deploy do |site|
  site.config.post_deploy_ran_at Time.now
end
