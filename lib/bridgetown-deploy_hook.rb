# frozen_string_literal: true

require_relative "bridgetown/deploy_hook/version"

# A progressive site generator and fullstack framework
#
# @see https://www.bridgetownrb.com/
module Bridgetown
  # A Bridgetown plugin that adds support for post-deploy webhooks
  #
  # Post-deploy actions receive the Bridgetown site as a block parameter so can
  # operate on the site as a whole if they wish. This could be for sending
  # Webmentions or other linkbacks, notifying your team of a deployment for a
  # client site, or anything else you might find yourself needing to do.
  #
  # @example Adding a post-deploy hook to send a Slack notification
  #
  #   Bridgetown::Hooks.register_one :site, :post_deploy do |site|
  #     SendSlackNotification.call(site)
  #   end
  module DeployHook
    # The Zeitwerk loader responsible for auto-loading constants
    #
    # @private
    Loader = Zeitwerk::Loader.for_gem(warn_on_extra_files: false).tap do |loader|
      loader.ignore(__FILE__)
      loader.ignore(File.join(__dir__, "bridgetown", "deploy_hook", "initializer"))
      loader.ignore(File.join(__dir__, "roda", "plugins", "deploy_hook"))
      loader.setup
    end
  end
end

require_relative "bridgetown/deploy_hook/initializer"
