# frozen_string_literal: true

Bridgetown.configuration(
  root_dir: __dir__,
  destination: Dir.mktmpdir("bridgetown-deploy_hook-integration-dest")
)

require "bridgetown-core/rack/boot"

Bridgetown::Rack.boot

run RodaApp.freeze.app
