# frozen_string_literal: true

if ENV["CI"] || ENV["COVERAGE"]
  require "simplecov"

  SimpleCov.start do
    add_filter "/test/"
  end

  SimpleCov.command_name "test:unit"
end

require "tmpdir"

require "minitest/autorun"
require "minitest/reporters"
require "pry"
require "pry-byebug"
require "bridgetown"
require "roda"
require "rack"
require "rack/test"

Bridgetown.begin!

require "bridgetown-deploy_hook"

Bridgetown.logger.log_level = :error

Dir["#{__dir__}/support/**/*.rb"].sort.each { |file| require file }

Minitest::Reporters.use! [
  Minitest::Reporters::DefaultReporter.new(
    color: true
  )
]

module Bridgetown
  class TestCase < Minitest::Test
    ROOT_DIR = File.expand_path("fixtures", __dir__)
    SOURCE_DIR = File.join(ROOT_DIR, "src")
    DEST_DIR = File.expand_path("dest", __dir__)

    def setup
      @root_dir = Dir.mktmpdir("bridgetown-deploy_hook-tests-src")
      @source_dir = File.join(@root_dir, "src")
      @dest_dir = Dir.mktmpdir("bridgetown-deploy_hook-tests-dest")
      FileUtils.cp_r "#{ROOT_DIR}/.", @root_dir
    end

    def teardown
      FileUtils.remove_entry(@root_dir)
      FileUtils.remove_entry(@dest_dir)
    end

    def root_dir(*files)
      File.join(@root_dir, *files)
    end

    def config_dir(*files)
      File.join(root_dir, "config", *files)
    end

    def source_dir(*files)
      File.join(@source_dir, *files)
    end

    def dest_dir(*files)
      File.join(@dest_dir, *files)
    end

    def maybe_reload_initializer(config)
      return if config.initializers && config.initializers[:"bridgetown-deploy_hook"]

      load "bridgetown/deploy_hook/initializer.rb"
    end

    def with_initializer(ruby)
      File.write(config_dir("initializers.rb"), ruby)

      yield if block_given?
    end

    def with_data(file, data = {})
      File.write(
        source_dir("_data/#{file}"),
        data.transform_keys(&:to_s).to_yaml.sub("---\n", "")
      )
    end

    def with_metadata(data = {})
      with_data("site_metadata.yml", data)

      yield
    end
  end
end
