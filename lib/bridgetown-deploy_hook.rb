# frozen_string_literal: true

require_relative "bridgetown/deploy_hook/version"

# A progressive site generator and fullstack framework
#
# @see https://www.bridgetownrb.com/
module Bridgetown
  # A Bridgetown plugin that adds support for post-deploy webhooks
  module DeployHook
    # The Zeitwerk loader responsible for auto-loading constants
    #
    # @private
    Loader = Zeitwerk::Loader.for_gem(warn_on_extra_files: false).tap do |loader|
      loader.ignore(__FILE__)
      loader.setup
    end
  end
end
