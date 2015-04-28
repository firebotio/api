source "https://rubygems.org"

gem "rails", "4.2.0"

gem "activeadmin", git: "https://github.com/activeadmin/activeadmin"
gem "activeadmin-sortable"
gem "active_model_serializers"
gem "attr_extras"
gem "bcrypt", "~> 3.1.7"
gem "dotenv-rails"
gem "draper"
gem "foreman"
gem "paperclip", "~> 4.2"
gem "paperclip-meta"
gem "paranoia", ">= 2.0"
gem "payload", require: "payload/railtie"
gem "pg"
gem "rack-cors", require: "rack/cors"
gem "redis-rails"
gem "sidekiq"
gem "unicorn"
gem "validates_email_format_of"

group :development, :test do
  gem "pry-byebug"
  gem "rspec-rails"
  gem "spring"
  gem "spring-commands-rspec"
end

group :development do
  gem "better_errors"
  gem "bundler-audit", require: false
  gem "license_finder", require: false
  gem "quiet_assets"
  gem "pry-rails"
  gem "rubocop", require: false
  gem "rubocop-rspec", require: false
end

group :test do
  # gem "capybara"
  # gem "capybara-webkit"
  gem "database_cleaner"
  gem "factory_girl_rails"
  gem "formulaic"
  gem "rspec-instafail", require: false
  gem "simplecov", require: false
  gem "shoulda", require: false
  gem "timecop"
end

gem "bson_ext"
gem "httparty"
gem "kaminari"
gem "mongoid"
gem "parse-ruby-client"
gem "rails-api"

group :test do
  gem "mongoid-rspec", "~> 2.0.0.rc1"
  gem "webmock"
end
