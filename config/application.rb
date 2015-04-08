require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Base
  class Application < Rails::Application
    config.cache_store = :redis_store, "#{ENV["REDIS_URL"]}/0/cache"

    %i(app/constraints app/jobs app/serializers lib).each do |path|
      autoload_path = [config.root, path].join "/"
      config.autoload_paths << autoload_path
    end

    config.middleware.insert_before 0, "Rack::Cors" do
      allow do
        origins "*"
        resource "*", headers: :any,
                      methods: %i(delete get options patch post put)
      end
    end

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # Add application specific config below this line
  end
end
