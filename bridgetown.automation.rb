# frozen_string_literal: true

add_bridgetown_plugin "bridgetown-deploy_hook"

say_status(:configuring, "route")

route = ask("What route do you want to use? (default: _bridgetown/deploy):")

say_status(:configuring, "authorization")

schemes = ask("What authorization scheme(s) do you want? Enter comma-separated values (e.g. bearer):")

parts = []

unless route.empty?
  parts << %(route: "#{route}")
end

unless schemes.empty?
  schemes
    .split(/,\s*/)
    .map { |scheme| "#{scheme}: ->(value) {}" }
    .then do |scheme_parts|
      parts << %(authorization: {#{scheme_parts.join(", ")}})
    end
end

unless parts.empty?
  parts.unshift("")
end

add_initializer "bridgetown-deploy_hook", parts.join(", ")

say(<<~MSG)

  Now, add and enable the plugin to your Roda app. In server/roda_app.rb:

    class RodaApp < Bridgetown::Rack::Roda
      plugin :bridgetown_ssr
      plugin :bridgetown_deploy_hook

      route do |r|
        r.bridgetown_deploy_hook
      end
    end
MSG
