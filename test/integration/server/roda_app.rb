# frozen_string_literal: true

class RodaApp < Bridgetown::Rack::Roda
  plugin(
    :common_logger,
    StringIO.new.tap do |io|
      io.singleton_class.define_method(:error) { |*| }
      io.singleton_class.define_method(:level=) { |*| }
      io.singleton_class.define_method(:warn) { |*| }
    end
  )
  plugin :bridgetown_ssr
  plugin :bridgetown_deploy_hook

  route do |r|
    r.bridgetown_deploy_hook
  end
end
