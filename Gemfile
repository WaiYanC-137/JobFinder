source "https://rubygems.org"

gem "rails", "~> 8.0.1"
gem "propshaft"
gem "pg"                             # Use PostgreSQL (for Heroku)
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "bcrypt", "~> 3.1.7"
gem "carrierwave"
gem "image_processing", "~> 1.2"
gem "kaminari"
gem "faker"
gem "phony_rails"
gem "mailgun-ruby", "~> 1.2"
gem "mail"
gem "dotenv-rails", groups: [:development, :test]

group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
  # Optional: Include mysql2 only for local dev
  gem 'mysql2', '>= 0.4.4'
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end

gem "tzinfo-data", platforms: %i[windows jruby]
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false
