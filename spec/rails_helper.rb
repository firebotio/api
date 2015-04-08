# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] = "test"
require "spec_helper"
require File.expand_path("../../config/environment", __FILE__)
require "rspec/rails"

# Add additional requires below this line. Rails is not loaded until this point!
require "shoulda"
require "paperclip/matchers"
require "paranoia/rspec"
require "payload/testing"
require "capybara/rails"
require "capybara/rspec"
require "validates_email_format_of/rspec_matcher"

Capybara.javascript_driver = :webkit

RSpec.singleton_class.class_eval do
  alias_method :feature, :describe
end

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join "spec/support/**/*.rb"].each { |file| require file }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  config.include FactoryGirl::Syntax::Methods
  config.include Shoulda::Matchers
  config.include Paperclip::Shoulda::Matchers
  config.include Payload::Testing
  config.include Formulaic::Dsl, type: :feature
  config.include Request::HeadersHelpers, type: :controller
  config.include Request::JsonHelpers, type: :controller

  config.before(:suite) do
    DatabaseCleaner.logger = Rails.logger
    DatabaseCleaner.clean_with(:truncation)

    DatabaseCleaner.cleaning do
      # Make sure all test factories are valid before trying to run any specs
      FactoryGirl.lint
    end
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    Timecop.return

    # %i(facebook google).each do |provider|
    #   OmniAuth.config.mock_auth[provider] = nil
    # end
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :deletion
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  # config.after(:suite) do
  #   # Remove test file uploads that are created within specs
  #   settings = Rails.application.config.paperclip_defaults
  #   dir = settings[:fog_credentials][:local_root]
  #   dir << "/" << settings[:fog_directory]
  #   FileUtils.rm_r dir if File.exist?(dir)
  # end

  config.before :each, type: %i(controller feature) do
    request.env[:dependencies] = Payload::RailsLoader.load
  end

  config.around :each do |spec|
    DatabaseCleaner.cleaning do
      spec.run
    end
  end
end
