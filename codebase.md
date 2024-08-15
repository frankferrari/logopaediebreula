# tailwind.config.js

```js
module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ]
}

```

# package.json

```json
{
  "name": "app",
  "private": true,
  "devDependencies": {
    "esbuild": "^0.23.0"
  },
  "scripts": {
    "build": "esbuild app/javascript/*.* --bundle --sourcemap --format=esm --outdir=app/assets/builds --public-path=/assets",
    "build:css": "tailwindcss -i ./app/assets/stylesheets/application.tailwind.css -o ./app/assets/builds/application.css --minify"
  },
  "dependencies": {
    "@hotwired/stimulus": "^3.2.2",
    "@hotwired/turbo-rails": "^8.0.5",
    "autoprefixer": "^10.4.20",
    "postcss": "^8.4.41",
    "tailwindcss": "^3.4.9"
  }
}

```

# config.ru

```ru
# This file is used by Rack-based servers to start the application.

require_relative "config/environment"

run Rails.application
Rails.application.load_server

```

# Rakefile

```
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

```

# README.md

```md
# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

```

# Procfile.dev

```dev
web: env RUBY_DEBUG_OPEN=true bin/rails server
js: yarn build --watch
css: yarn build:css --watch

```

# Gemfile

```
source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

# Core Rails gems
gem 'pg', '~> 1.1'
gem 'puma', '~> 6.4'
gem 'rails', '~> 7.1.3.4'

# Asset management and frontend
gem 'jsbundling-rails'
gem 'propshaft'
gem 'stimulus-rails'
gem 'tailwindcss-rails'
gem 'turbo-rails'

# Rate limiting
gem 'rack-attack'

# Authentication and Authorization
gem 'devise'
gem 'pundit'

# Background Jobs
gem 'sidekiq'

# Internationalization
gem 'rails-i18n', '~> 7.0.0'

# Other gems
gem 'bootsnap', require: false
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', :require => false
  gem 'rspec-rails', :require => false
end

group :development do
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'faker'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 6.0'
  gem 'webdrivers'
end

```

# Dockerfile

```
# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.2.2
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# Rails app lives here
WORKDIR /rails

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"


# Throw-away build stage to reduce size of final image
FROM base as build

# Install packages needed to build gems and node modules
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential curl git libpq-dev libvips node-gyp pkg-config python-is-python3

# Install JavaScript dependencies
ARG NODE_VERSION=22.4.1
ARG YARN_VERSION=1.22.21
ENV PATH=/usr/local/node/bin:$PATH
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
    /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
    npm install -g yarn@$YARN_VERSION && \
    rm -rf /tmp/node-build-master

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Install node modules
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/


# Final stage for app image
FROM base

# Install packages needed for deployment
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libvips postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy built artifacts: gems, application
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER rails:rails

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server"]

```

# .ruby-version

```
3.2.2

```

# .rubocop.yml

```yml
require:
  - rubocop-rails
  - rubocop-rspec

AllCops:
  NewCops: enable
  Exclude:
    - 'db/**/*'
    - 'config/**/*'
    - 'script/**/*'
    - 'bin/**/*'
    - 'vendor/**/*'
    - 'node_modules/**/*'

Style/Documentation:
  Enabled: false

Metrics/BlockLength:
  Exclude:
    - 'spec/**/*'

# Add more rules as needed
```

# .rspec

```
--require spec_helper

```

# .node-version

```
22.4.1

```

# .gitignore

```
# See https://help.github.com/articles/ignoring-files for more about ignoring files.
#
# If you find yourself ignoring temporary files generated by your text editor
# or operating system, you probably want to add a global ignore instead:
#   git config --global core.excludesfile '~/.gitignore_global'

# Ignore bundler config.
/.bundle

# Ignore all environment files (except templates).
/.env*
!/.env*.erb

# Ignore all logfiles and tempfiles.
/log/*
/tmp/*
!/log/.keep
!/tmp/.keep

# Ignore pidfiles, but keep the directory.
/tmp/pids/*
!/tmp/pids/
!/tmp/pids/.keep

# Ignore storage (uploaded files in development and any SQLite databases).
/storage/*
!/storage/.keep
/tmp/storage/*
!/tmp/storage/
!/tmp/storage/.keep

/public/assets

# Ignore master key for decrypting credentials and more.
/config/master.key

/app/assets/builds/*
!/app/assets/builds/.keep

/node_modules

```

# .gitattributes

```
# See https://git-scm.com/docs/gitattributes for more about git attribute files.

# Mark the database schema as having been generated.
db/schema.rb linguist-generated

# Mark any vendored files as having been vendored.
vendor/* linguist-vendored
config/credentials/*.yml.enc diff=rails_credentials
config/credentials.yml.enc diff=rails_credentials

```

# .dockerignore

```
# See https://docs.docker.com/engine/reference/builder/#dockerignore-file for more about ignoring files.

# Ignore git directory.
/.git/

# Ignore bundler config.
/.bundle

# Ignore all environment files (except templates).
/.env*
!/.env*.erb

# Ignore all default key files.
/config/master.key
/config/credentials/*.key

# Ignore all logfiles and tempfiles.
/log/*
/tmp/*
!/log/.keep
!/tmp/.keep

# Ignore pidfiles, but keep the directory.
/tmp/pids/*
!/tmp/pids/.keep

# Ignore storage (uploaded files in development and any SQLite databases).
/storage/*
!/storage/.keep
/tmp/storage/*
!/tmp/storage/.keep

# Ignore assets.
/node_modules/
/app/assets/builds/*
!/app/assets/builds/.keep
/public/assets

```

# .aidigestignore

```
app/assets/builds
log/
tmp/
storage/
config/locales
config/credentials/
```

# test/test_helper.rb

```rb
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

```

# test/application_system_test_case.rb

```rb
require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
end

```

# public/robots.txt

```txt
# See https://www.robotstxt.org/robotstxt.html for documentation on how to use the robots.txt file

```

# public/favicon.ico

```ico

```

# public/apple-touch-icon.png

This is a binary file of the type: Image

# public/apple-touch-icon-precomposed.png

This is a binary file of the type: Image

# public/500.html

```html
<!DOCTYPE html>
<html>
<head>
  <title>We're sorry, but something went wrong (500)</title>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <style>
  .rails-default-error-page {
    background-color: #EFEFEF;
    color: #2E2F30;
    text-align: center;
    font-family: arial, sans-serif;
    margin: 0;
  }

  .rails-default-error-page div.dialog {
    width: 95%;
    max-width: 33em;
    margin: 4em auto 0;
  }

  .rails-default-error-page div.dialog > div {
    border: 1px solid #CCC;
    border-right-color: #999;
    border-left-color: #999;
    border-bottom-color: #BBB;
    border-top: #B00100 solid 4px;
    border-top-left-radius: 9px;
    border-top-right-radius: 9px;
    background-color: white;
    padding: 7px 12% 0;
    box-shadow: 0 3px 8px rgba(50, 50, 50, 0.17);
  }

  .rails-default-error-page h1 {
    font-size: 100%;
    color: #730E15;
    line-height: 1.5em;
  }

  .rails-default-error-page div.dialog > p {
    margin: 0 0 1em;
    padding: 1em;
    background-color: #F7F7F7;
    border: 1px solid #CCC;
    border-right-color: #999;
    border-left-color: #999;
    border-bottom-color: #999;
    border-bottom-left-radius: 4px;
    border-bottom-right-radius: 4px;
    border-top-color: #DADADA;
    color: #666;
    box-shadow: 0 3px 8px rgba(50, 50, 50, 0.17);
  }
  </style>
</head>

<body class="rails-default-error-page">
  <!-- This file lives in public/500.html -->
  <div class="dialog">
    <div>
      <h1>We're sorry, but something went wrong.</h1>
    </div>
    <p>If you are the application owner check the logs for more information.</p>
  </div>
</body>
</html>

```

# public/422.html

```html
<!DOCTYPE html>
<html>
<head>
  <title>The change you wanted was rejected (422)</title>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <style>
  .rails-default-error-page {
    background-color: #EFEFEF;
    color: #2E2F30;
    text-align: center;
    font-family: arial, sans-serif;
    margin: 0;
  }

  .rails-default-error-page div.dialog {
    width: 95%;
    max-width: 33em;
    margin: 4em auto 0;
  }

  .rails-default-error-page div.dialog > div {
    border: 1px solid #CCC;
    border-right-color: #999;
    border-left-color: #999;
    border-bottom-color: #BBB;
    border-top: #B00100 solid 4px;
    border-top-left-radius: 9px;
    border-top-right-radius: 9px;
    background-color: white;
    padding: 7px 12% 0;
    box-shadow: 0 3px 8px rgba(50, 50, 50, 0.17);
  }

  .rails-default-error-page h1 {
    font-size: 100%;
    color: #730E15;
    line-height: 1.5em;
  }

  .rails-default-error-page div.dialog > p {
    margin: 0 0 1em;
    padding: 1em;
    background-color: #F7F7F7;
    border: 1px solid #CCC;
    border-right-color: #999;
    border-left-color: #999;
    border-bottom-color: #999;
    border-bottom-left-radius: 4px;
    border-bottom-right-radius: 4px;
    border-top-color: #DADADA;
    color: #666;
    box-shadow: 0 3px 8px rgba(50, 50, 50, 0.17);
  }
  </style>
</head>

<body class="rails-default-error-page">
  <!-- This file lives in public/422.html -->
  <div class="dialog">
    <div>
      <h1>The change you wanted was rejected.</h1>
      <p>Maybe you tried to change something you didn't have access to.</p>
    </div>
    <p>If you are the application owner check the logs for more information.</p>
  </div>
</body>
</html>

```

# public/404.html

```html
<!DOCTYPE html>
<html>
<head>
  <title>The page you were looking for doesn't exist (404)</title>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <style>
  .rails-default-error-page {
    background-color: #EFEFEF;
    color: #2E2F30;
    text-align: center;
    font-family: arial, sans-serif;
    margin: 0;
  }

  .rails-default-error-page div.dialog {
    width: 95%;
    max-width: 33em;
    margin: 4em auto 0;
  }

  .rails-default-error-page div.dialog > div {
    border: 1px solid #CCC;
    border-right-color: #999;
    border-left-color: #999;
    border-bottom-color: #BBB;
    border-top: #B00100 solid 4px;
    border-top-left-radius: 9px;
    border-top-right-radius: 9px;
    background-color: white;
    padding: 7px 12% 0;
    box-shadow: 0 3px 8px rgba(50, 50, 50, 0.17);
  }

  .rails-default-error-page h1 {
    font-size: 100%;
    color: #730E15;
    line-height: 1.5em;
  }

  .rails-default-error-page div.dialog > p {
    margin: 0 0 1em;
    padding: 1em;
    background-color: #F7F7F7;
    border: 1px solid #CCC;
    border-right-color: #999;
    border-left-color: #999;
    border-bottom-color: #999;
    border-bottom-left-radius: 4px;
    border-bottom-right-radius: 4px;
    border-top-color: #DADADA;
    color: #666;
    box-shadow: 0 3px 8px rgba(50, 50, 50, 0.17);
  }
  </style>
</head>

<body class="rails-default-error-page">
  <!-- This file lives in public/404.html -->
  <div class="dialog">
    <div>
      <h1>The page you were looking for doesn't exist.</h1>
      <p>You may have mistyped the address or the page may have moved.</p>
    </div>
    <p>If you are the application owner check the logs for more information.</p>
  </div>
</body>
</html>

```

# config/storage.yml

```yml
test:
  service: Disk
  root: <%= Rails.root.join("tmp/storage") %>

local:
  service: Disk
  root: <%= Rails.root.join("storage") %>

# Use bin/rails credentials:edit to set the AWS secrets (as aws:access_key_id|secret_access_key)
# amazon:
#   service: S3
#   access_key_id: <%= Rails.application.credentials.dig(:aws, :access_key_id) %>
#   secret_access_key: <%= Rails.application.credentials.dig(:aws, :secret_access_key) %>
#   region: us-east-1
#   bucket: your_own_bucket-<%= Rails.env %>

# Remember not to checkin your GCS keyfile to a repository
# google:
#   service: GCS
#   project: your_project
#   credentials: <%= Rails.root.join("path/to/gcs.keyfile") %>
#   bucket: your_own_bucket-<%= Rails.env %>

# Use bin/rails credentials:edit to set the Azure Storage secret (as azure_storage:storage_access_key)
# microsoft:
#   service: AzureStorage
#   storage_account_name: your_account_name
#   storage_access_key: <%= Rails.application.credentials.dig(:azure_storage, :storage_access_key) %>
#   container: your_container_name-<%= Rails.env %>

# mirror:
#   service: Mirror
#   primary: local
#   mirrors: [ amazon, google, microsoft ]

```

# config/routes.rb

```rb
Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end

```

# config/puma.rb

```rb
# This configuration file will be evaluated by Puma. The top-level methods that
# are invoked here are part of Puma's configuration DSL. For more information
# about methods provided by the DSL, see https://puma.io/puma/Puma/DSL.html.

# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

# Specifies that the worker count should equal the number of processors in production.
if ENV["RAILS_ENV"] == "production"
  require "concurrent-ruby"
  worker_count = Integer(ENV.fetch("WEB_CONCURRENCY") { Concurrent.physical_processor_count })
  workers worker_count if worker_count > 1
end

# Specifies the `worker_timeout` threshold that Puma will use to wait before
# terminating a worker in development environments.
worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
port ENV.fetch("PORT") { 3000 }

# Specifies the `environment` that Puma will run in.
environment ENV.fetch("RAILS_ENV") { "development" }

# Specifies the `pidfile` that Puma will use.
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# Allow puma to be restarted by `bin/rails restart` command.
plugin :tmp_restart

```

# config/master.key

```key
0857cb8f5886e41c2226bff52d643ff5
```

# config/environment.rb

```rb
# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

```

# config/database.yml

```yml
# PostgreSQL. Versions 9.3 and up are supported.
#
# Install the pg driver:
#   gem install pg
# On macOS with Homebrew:
#   gem install pg -- --with-pg-config=/usr/local/bin/pg_config
# On Windows:
#   gem install pg
#       Choose the win32 build.
#       Install PostgreSQL and put its /bin directory on your path.
#
# Configure Using Gemfile
# gem "pg"
#
default: &default
  adapter: postgresql
  encoding: unicode
  # For details on connection pooling, see Rails configuration guide
  # https://guides.rubyonrails.org/configuring.html#database-pooling
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>

development:
  <<: *default
  database: rails_logopaediebreula_development

  # The specified database role being used to connect to PostgreSQL.
  # To create additional roles in PostgreSQL see `$ createuser --help`.
  # When left blank, PostgreSQL will use the default role. This is
  # the same name as the operating system user running Rails.
  #username: rails_logopaediebreula

  # The password associated with the PostgreSQL role (username).
  #password:

  # Connect on a TCP socket. Omitted by default since the client uses a
  # domain socket that doesn't need configuration. Windows does not have
  # domain sockets, so uncomment these lines.
  #host: localhost

  # The TCP port the server listens on. Defaults to 5432.
  # If your server runs on a different port number, change accordingly.
  #port: 5432

  # Schema search path. The server defaults to $user,public
  #schema_search_path: myapp,sharedapp,public

  # Minimum log levels, in increasing order:
  #   debug5, debug4, debug3, debug2, debug1,
  #   log, notice, warning, error, fatal, and panic
  # Defaults to warning.
  #min_messages: notice

# Warning: The database defined as "test" will be erased and
# re-generated from your development database when you run "rake".
# Do not set this db to the same as development or production.
test:
  <<: *default
  database: rails_logopaediebreula_test

# As with config/credentials.yml, you never want to store sensitive information,
# like your database password, in your source code. If your source code is
# ever seen by anyone, they now have access to your database.
#
# Instead, provide the password or a full connection URL as an environment
# variable when you boot the app. For example:
#
#   DATABASE_URL="postgres://myuser:mypass@localhost/somedatabase"
#
# If the connection URL is provided in the special DATABASE_URL environment
# variable, Rails will automatically merge its configuration values on top of
# the values provided in this file. Alternatively, you can specify a connection
# URL environment variable explicitly:
#
#   production:
#     url: <%= ENV["MY_APP_DATABASE_URL"] %>
#
# Read https://guides.rubyonrails.org/configuring.html#configuring-a-database
# for a full overview on how database connection configuration can be specified.
#
production:
  <<: *default
  database: rails_logopaediebreula_production
  username: rails_logopaediebreula
  password: <%= ENV["RAILS_LOGOPAEDIEBREULA_DATABASE_PASSWORD"] %>

```

# config/credentials.yml.enc

```enc
rdfQWRfzuqtC7OEbm1xpUe4cvRjAShGMoX12XYWbW5KZ7Ay7esHKYsmcTS2MZ0Fxa1E25rH7kx5tC+VN5AtmbizInVZaZMTEZPEpKb3GCMnsnXl3Ml3rmA/N4G2T2eiJ8bASmQZzhHflMz8JYAhyNMc8GgRhkqZ2W1YRWVYuWlqoU/iA78fJy2x2YkMaMRm0Knw+nMVrglP8uX9OJWlA+4JW3OLBGIy7Sl0DRyahNPhHd3Xy+0YvO1i3X2Ueh9vhc/Xn0WF+p4i1jS/N45pKpFQmDWW9AItg3RgmbCNYfxvdo8JpxhGNEVTsaaPKQyWMhtZk4A5HuaWuKKTbF0+e+jO0r4fP2U39kO867/MhgDDwWcVJl/CbxnJWgq5l1Uih4rl0yUgyAABPU7MzfkC+uk+49nlv--760mp41K3Xx9ki1K--O5Jkk/Ht66nyq5pAyDlsaA==
```

# config/cable.yml

```yml
development:
  adapter: async

test:
  adapter: test

production:
  adapter: redis
  url: <%= ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" } %>
  channel_prefix: rails_logopaediebreula_production

```

# config/boot.rb

```rb
ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.
require "bootsnap/setup" # Speed up boot time by caching expensive operations.

```

# config/application.rb

```rb
require_relative "boot"
require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)


module RailsLogopaediebreula
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    config.autoloader = :zeitwerk
    
    config.autoload_lib(ignore: %w(assets tasks))

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    config.time_zone = 'Berlin'

    # Set default locale to German
    config.i18n.default_locale = :de
    config.i18n.available_locales = [:de]

    # Use default German locale settings for date, time, and number formatting
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
  end
end
 

```

# db/seeds.rb

```rb
# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require_relative '../app/models/shared/location'
require_relative '../app/models/shared/language'
require_relative '../app/models/shared/focusarea'

# Clear existing data
puts "Clearing existing data..."
Shared::Location.destroy_all
Shared::Language.destroy_all
Shared::Focusarea.destroy_all

# Seed Locations
puts "Seeding Locations..."
locations = ["Corinthstraße", "Sonntagstraße"]
locations.each do |name|
  Shared::Location.create!(name: name)
end
puts "Created #{Shared::Location.count} locations"

# Seed Languages
puts "Seeding Languages..."
languages = ["Deutsch", "Englisch", "Tschechisch", "Niederländisch"]
languages.each do |name|
  Shared::Language.create!(name: name)
end
puts "Created #{Shared::Language.count} languages"

# Seed Focus Area
puts "Seeding Focus Area..."
focusareas = [
  "Aussprachestörung",
  "Autismus",
  "Essverhaltensstörung",
  "Fütterstörung",
  "Myofunktionelle Störung",
  "Orale Restriktion",
  "Poltern",
  "Selektiver Mutismus",
  "Sprachentwicklungsstörungen",
  "Stimmstörungen",
  "Stimmtraining bei Trans*",
  "Stottern",
  "Unterstützte Kommunikation",
  "neurologische Störung"
]
focusareas.each do |name|
  Shared::Focusarea.create!(name: name)
end
puts "Created #{Shared::Focusarea.count} areas of focus"

puts "Seeding completed successfully!"
```

# db/schema.rb

```rb
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_08_15_103013) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clients", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "client_first_name"
    t.string "client_last_name"
    t.string "address", null: false
    t.string "phone_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_clients_on_user_id"
  end

  create_table "employees", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "employee_first_name", null: false
    t.string "employee_last_name", null: false
    t.date "date_of_birth"
    t.text "short_description"
    t.text "long_description"
    t.boolean "is_admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_employees_on_user_id"
  end

  create_table "employees_focusareas", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.bigint "focusarea_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id", "focusarea_id"], name: "index_employees_focusareas_on_employee_id_and_focusarea_id", unique: true
    t.index ["employee_id"], name: "index_employees_focusareas_on_employee_id"
    t.index ["focusarea_id"], name: "index_employees_focusareas_on_focusarea_id"
  end

  create_table "employees_languages", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.bigint "language_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id", "language_id"], name: "index_employees_languages_on_employee_id_and_language_id", unique: true
    t.index ["employee_id"], name: "index_employees_languages_on_employee_id"
    t.index ["language_id"], name: "index_employees_languages_on_language_id"
  end

  create_table "employees_locations", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.bigint "location_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id", "location_id"], name: "index_employees_locations_on_employee_id_and_location_id", unique: true
    t.index ["employee_id"], name: "index_employees_locations_on_employee_id"
    t.index ["location_id"], name: "index_employees_locations_on_location_id"
  end

  create_table "focusareas", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "languages", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "patients", force: :cascade do |t|
    t.string "patient_first_name", null: false
    t.string "patient_last_name", null: false
    t.date "date_of_birth", null: false
    t.integer "gender", null: false
    t.boolean "has_prescription", null: false
    t.integer "health_insurance", null: false
    t.text "diagnosis", null: false
    t.string "kita_name"
    t.boolean "has_i_status"
    t.bigint "client_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_patients_on_client_id"
  end

  create_table "patients_languages", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.bigint "language_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["language_id"], name: "index_patients_languages_on_language_id"
    t.index ["patient_id", "language_id"], name: "index_patient_profile_languages_uniqueness", unique: true
    t.index ["patient_id"], name: "index_patients_languages_on_patient_id"
  end

  create_table "patients_locations", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.bigint "location_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_patients_locations_on_location_id"
    t.index ["patient_id", "location_id"], name: "index_patient_profile_locations_uniqueness", unique: true
    t.index ["patient_id"], name: "index_patients_locations_on_patient_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "clients", "users"
  add_foreign_key "employees", "users"
  add_foreign_key "employees_focusareas", "employees"
  add_foreign_key "employees_focusareas", "focusareas"
  add_foreign_key "employees_languages", "employees"
  add_foreign_key "employees_languages", "languages"
  add_foreign_key "employees_locations", "employees"
  add_foreign_key "employees_locations", "locations"
  add_foreign_key "patients", "clients"
  add_foreign_key "patients_languages", "languages"
  add_foreign_key "patients_languages", "patients"
  add_foreign_key "patients_locations", "locations"
  add_foreign_key "patients_locations", "patients"
end

```

# spec/spec_helper.rb

```rb
# This file was generated by the `rails generate rspec:install` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# The generated `.rspec` file contains `--require spec_helper` which will cause
# this file to always be loaded, without a need to explicitly require it in any
# files.
#
# Given that it is always loaded, you are encouraged to keep this file as
# light-weight as possible. Requiring heavyweight dependencies from this file
# will add to the boot time of your test suite on EVERY test run, even for an
# individual file that may not need all of that loaded. Instead, consider making
# a separate helper file that requires the additional dependencies and performs
# the additional setup, and require it from the spec files that actually need
# it.
#
# See https://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    #     be_bigger_than(2).and_smaller_than(4).description
    #     # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #     # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  # This option will default to `:apply_to_host_groups` in RSpec 4 (and will
  # have no way to turn it off -- the option exists only for backwards
  # compatibility in RSpec 3). It causes shared context metadata to be
  # inherited by the metadata hash of host groups and examples, rather than
  # triggering implicit auto-inclusion in groups with matching metadata.
  config.shared_context_metadata_behavior = :apply_to_host_groups

# The settings below are suggested to provide a good initial experience
# with RSpec, but feel free to customize to your heart's content.
=begin
  # This allows you to limit a spec run to individual examples or groups
  # you care about by tagging them with `:focus` metadata. When nothing
  # is tagged with `:focus`, all examples get run. RSpec also provides
  # aliases for `it`, `describe`, and `context` that include `:focus`
  # metadata: `fit`, `fdescribe` and `fcontext`, respectively.
  config.filter_run_when_matching :focus

  # Allows RSpec to persist some state between runs in order to support
  # the `--only-failures` and `--next-failure` CLI options. We recommend
  # you configure your source control system to ignore this file.
  config.example_status_persistence_file_path = "spec/examples.txt"

  # Limits the available syntax to the non-monkey patched syntax that is
  # recommended. For more details, see:
  # https://rspec.info/features/3-12/rspec-core/configuration/zero-monkey-patching-mode/
  config.disable_monkey_patching!

  # Many RSpec users commonly either run the entire suite or an individual
  # file, and it's useful to allow more verbose output when running an
  # individual spec file.
  if config.files_to_run.one?
    # Use the documentation formatter for detailed output,
    # unless a formatter has already been configured
    # (e.g. via a command-line flag).
    config.default_formatter = "doc"
  end

  # Print the 10 slowest examples and example groups at the
  # end of the spec run, to help surface which specs are running
  # particularly slow.
  config.profile_examples = 10

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed
=end
end

```

# spec/rails_helper.rb

```rb
# This file is copied to spec/ when you run 'rails generate rspec:install'

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'

# Add additional requires below this line. Rails is not loaded until this point!
require 'factory_bot_rails'

# ----------------------------------------
# 1. Test File Management
# ----------------------------------------

# Checks for pending migrations and applies them before tests are run.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

# Automatically require all files in the support directory
# Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }

# ----------------------------------------
# 2. RSpec Configuration
# ----------------------------------------

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_paths = "#{Rails.root.join('spec/fixtures')}"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  # Explicitly require namespaced models
  Rails.application.eager_load!

  # ----------------------------------------
  # 3. FactoryBot Configuration
  # ----------------------------------------

  # Include FactoryBot methods
  config.include FactoryBot::Syntax::Methods

  # Automatically find definitions in spec/factories
  config.before(:suite) do
    FactoryBot.find_definitions
  end

  # ----------------------------------------
  # 4. Database Cleaner Configuration
  # ----------------------------------------

  # (Optional) Add Database Cleaner configuration here if you're using it

  # ----------------------------------------
  # 5. Shoulda Matchers Configuration
  # ----------------------------------------

  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end

  # ----------------------------------------
  # 6. Custom Helper Methods
  # ----------------------------------------

  # Add any custom helper methods for your tests here
end

```

# .ruby-lsp/main_lockfile_hash

```
d3bbb5027bdc391e1a1d9f538006ad823ee9d0b949cd319bba21fd90117e379d
```

# .ruby-lsp/last_updated

```
2024-08-15T09:20:06+02:00
```

# .ruby-lsp/Gemfile

```
# This custom gemfile is automatically generated by the Ruby LSP.
# It should be automatically git ignored, but in any case: do not commit it to your repository.

eval_gemfile(File.expand_path("../Gemfile", __dir__))
gem "ruby-lsp", require: false, group: :development
gem "ruby-lsp-rails", require: false, group: :development
```

# .ruby-lsp/.gitignore

```
*
```

# test/system/.keep

```

```

# test/models/.keep

```

```

# test/integration/.keep

```

```

# test/helpers/.keep

```

```

# test/controllers/.keep

```

```

# test/mailers/.keep

```

```

# lib/tasks/.keep

```

```

# lib/assets/.keep

```

```

# config/environments/test.rb

```rb
require "active_support/core_ext/integer/time"

# The test environment is used exclusively to run your application's
# test suite. You never need to work with it otherwise. Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs. Don't rely on the data there!

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # While tests run files are not watched, reloading is not necessary.
  config.enable_reloading = false

  # Eager loading loads your entire application. When running a single test locally,
  # this is usually not necessary, and can slow down your test suite. However, it's
  # recommended that you enable it in continuous integration systems to ensure eager
  # loading is working properly before deploying your code.
  config.eager_load = ENV["CI"].present?

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{1.hour.to_i}"
  }

  # Show full error reports and disable caching.
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  # Render exception templates for rescuable exceptions and raise for other exceptions.
  config.action_dispatch.show_exceptions = :rescuable

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Store uploaded files on the local file system in a temporary directory.
  config.active_storage.service = :test

  config.action_mailer.perform_caching = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Raise error when a before_action's only/except options reference missing actions
  config.action_controller.raise_on_missing_callback_actions = true

  config.eager_load = false
  config.autoloader = :classic
end

```

# config/environments/production.rb

```rb
require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # Ensures that a master key has been made available in ENV["RAILS_MASTER_KEY"], config/master.key, or an environment
  # key such as config/credentials/production.key. This key is used to decrypt credentials (and other encrypted files).
  # config.require_master_key = true

  # Disable serving static files from `public/`, relying on NGINX/Apache to do so instead.
  # config.public_file_server.enabled = false

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = "http://assets.example.com"

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for Apache
  # config.action_dispatch.x_sendfile_header = "X-Accel-Redirect" # for NGINX

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Mount Action Cable outside main process or domain.
  # config.action_cable.mount_path = nil
  # config.action_cable.url = "wss://example.com/cable"
  # config.action_cable.allowed_request_origins = [ "http://example.com", /http:\/\/example.*/ ]

  # Assume all access to the app is happening through a SSL-terminating reverse proxy.
  # Can be used together with config.force_ssl for Strict-Transport-Security and secure cookies.
  # config.assume_ssl = true

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # Log to STDOUT by default
  config.logger = ActiveSupport::Logger.new(STDOUT)
    .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
    .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]

  # "info" includes generic and useful information about system operation, but avoids logging too much
  # information to avoid inadvertent exposure of personally identifiable information (PII). If you
  # want to log everything, set the level to "debug".
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Use a real queuing backend for Active Job (and separate queues per environment).
  # config.active_job.queue_adapter = :resque
  # config.active_job.queue_name_prefix = "rails_logopaediebreula_production"

  config.action_mailer.perform_caching = false

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Don't log any deprecations.
  config.active_support.report_deprecations = false

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Enable DNS rebinding protection and other `Host` header attacks.
  # config.hosts = [
  #   "example.com",     # Allow requests from example.com
  #   /.*\.example\.com/ # Allow requests from subdomains like `www.example.com`
  # ]
  # Skip DNS rebinding protection for the default health check endpoint.
  # config.host_authorization = { exclude: ->(request) { request.path == "/up" } }
end

```

# config/environments/development.rb

```rb
require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded any time
  # it changes. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.enable_reloading = true

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable server timing
  config.server_timing = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }


  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Highlight code that enqueued background job in logs.
  config.active_job.verbose_enqueue_logs = true


  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Uncomment if you wish to allow Action Cable access from any origin.
  # config.action_cable.disable_request_forgery_protection = true

  # Raise error when a before_action's only/except options reference missing actions
  config.action_controller.raise_on_missing_callback_actions = true
end

```

# config/initializers/zeitwerk.rb

```rb
Rails.application.config.to_prepare do
  Rails.autoloaders.main.push_dir(Rails.root.join("app/models/shared"), namespace: Shared)
  Rails.autoloaders.main.push_dir(Rails.root.join("app/models/employee"), namespace: Employee)
  Rails.autoloaders.main.push_dir(Rails.root.join("app/models/client"), namespace: Client)
end
```

# config/initializers/sidekiq.rb

```rb
Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0') }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0') }
end

```

# config/initializers/rack_attack.rb

```rb
class Rack::Attack
  # Throttle all requests by IP (60rpm)
  throttle('req/ip', limit: 300, period: 5.minutes) do |req|
    req.ip
  end

  # Throttle POST requests to /login by IP address
  throttle('logins/ip', limit: 5, period: 20.seconds) do |req|
    req.ip if req.path == '/users/sign_in' && req.post?
  end
end

```

# config/initializers/permissions_policy.rb

```rb
# Be sure to restart your server when you modify this file.

# Define an application-wide HTTP permissions policy. For further
# information see: https://developers.google.com/web/updates/2018/06/feature-policy

# Rails.application.config.permissions_policy do |policy|
#   policy.camera      :none
#   policy.gyroscope   :none
#   policy.microphone  :none
#   policy.usb         :none
#   policy.fullscreen  :self
#   policy.payment     :self, "https://secure.example.com"
# end

```

# config/initializers/inflections.rb

```rb
# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, "\\1en"
#   inflect.singular /^(ox)en/i, "\\1"
#   inflect.irregular "person", "people"
#   inflect.uncountable %w( fish sheep )
# end

# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.acronym "RESTful"
# end

```

# config/initializers/filter_parameter_logging.rb

```rb
# Be sure to restart your server when you modify this file.

# Configure parameters to be partially matched (e.g. passw matches password) and filtered from the log file.
# Use this to limit dissemination of sensitive information.
# See the ActiveSupport::ParameterFilter documentation for supported notations and behaviors.
Rails.application.config.filter_parameters += [
  :passw, :secret, :token, :_key, :crypt, :salt, :certificate, :otp, :ssn
]

```

# config/initializers/devise.rb

```rb
# frozen_string_literal: true

Devise.setup do |config|
  # The secret key used by Devise. Devise uses this key to generate
  # random tokens. Changing this key will render invalid all existing
  # confirmation, reset password and unlock tokens in the database.
  config.secret_key = Rails.application.credentials.secret_key_base

  # ==> Controller configuration
  # Configure the parent class to the devise controllers.
  # config.parent_controller = 'DeviseController'

  # ==> Mailer Configuration
  config.mailer_sender = 'noreply@example.com'

  # Configure the class responsible to send e-mails.
  # config.mailer = 'Devise::Mailer'

  # ==> ORM configuration
  require 'devise/orm/active_record'

  # ==> Configuration for any authentication mechanism
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 12

  # ==> Configuration for :database_authenticatable
  config.pepper = Rails.application.credentials.devise_pepper

  # ==> Configuration for :confirmable
  config.allow_unconfirmed_access_for = 2.days
  config.confirm_within = 3.days

  # ==> Configuration for :rememberable
  config.remember_for = 2.weeks
  config.extend_remember_period = false

  # ==> Configuration for :validatable
  config.password_length = 8..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  # ==> Navigation configuration
  config.sign_out_via = :delete

end
```

# config/initializers/content_security_policy.rb

```rb
# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

# Rails.application.configure do
#   config.content_security_policy do |policy|
#     policy.default_src :self, :https
#     policy.font_src    :self, :https, :data
#     policy.img_src     :self, :https, :data
#     policy.object_src  :none
#     policy.script_src  :self, :https
#     policy.style_src   :self, :https
#     # Specify URI for violation reports
#     # policy.report_uri "/csp-violation-report-endpoint"
#   end
#
#   # Generate session nonces for permitted importmap, inline scripts, and inline styles.
#   config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
#   config.content_security_policy_nonce_directives = %w(script-src style-src)
#
#   # Report violations without enforcing the policy.
#   # config.content_security_policy_report_only = true
# end

```

# spec/factories/users.rb

```rb
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password123' }
    password_confirmation { 'password123' }

    trait :with_employee do
      after(:create) do |user|
        create(:employee, user: user)
      end
    end

    trait :with_client do
      after(:create) do |user|
        create(:client, user: user)
      end
    end
  end
end
```

# spec/factories/patients.rb

```rb
FactoryBot.define do
  factory :patient, class: 'Client::Patient' do
    client
    patient_first_name { Faker::Name.first_name }
    patient_last_name { Faker::Name.last_name }
    date_of_birth { Faker::Date.birthday(min_age: 1, max_age: 100) }
    gender { Client::Patient.genders.keys.sample }
    has_prescription { [true, false].sample }
    health_insurance { Client::Patient.health_insurances.keys.sample }
    diagnosis { Faker::Lorem.sentence }
    kita_name { Faker::Company.name }
    has_i_status { [true, false].sample }

    trait :with_languages do
      transient do
        languages_count { 2 }
      end

      after(:create) do |patient, evaluator|
        create_list(:patients_languages, evaluator.languages_count, patient: patient)
      end
    end

    trait :with_locations do
      transient do
        locations_count { 2 }
      end

      after(:create) do |patient, evaluator|
        create_list(:patients_locations, evaluator.locations_count, patient: patient)
      end
    end
  end
end
```

# spec/factories/employees.rb

```rb
FactoryBot.define do
  factory :employee, class: 'Employee::Employee' do
    user
    employee_first_name { Faker::Name.first_name }
    employee_last_name { Faker::Name.last_name }
    date_of_birth { Faker::Date.birthday(min_age: 18, max_age: 65) }
    short_description { Faker::Lorem.paragraph }
    long_description { Faker::Lorem.paragraphs(number: 3).join("\n\n") }
    is_admin { false }

    trait :admin do
      is_admin { true }
    end

    trait :with_focusareas do
      transient do
        focusareas_count { 2 }
      end

      after(:create) do |employee, evaluator|
        create_list(:employees_focusareas, evaluator.focusareas_count, employee: employee)
      end
    end

    trait :with_languages do
      transient do
        languages_count { 2 }
      end

      after(:create) do |employee, evaluator|
        create_list(:employees_languages, evaluator.languages_count, employee: employee)
      end
    end

    trait :with_locations do
      transient do
        locations_count { 2 }
      end

      after(:create) do |employee, evaluator|
        create_list(:employees_locations, evaluator.locations_count, employee: employee)
      end
    end
  end
end
```

# spec/factories/clients.rb

```rb
FactoryBot.define do
  factory :client, class: 'Client::Client' do
    user
    client_first_name { Faker::Name.first_name }
    client_last_name { Faker::Name.last_name }
    address { Faker::Address.full_address }
    phone_number { Faker::PhoneNumber.phone_number }
  end
end
```

# spec/factories/associations.rb

```rb
FactoryBot.define do
  factory :employees_focusareas, class: 'Employee::EmployeesFocusareas' do
    employee
    focusarea { create(:focusarea) }
  end

  factory :employees_languages, class: 'Employee::EmployeesLanguages' do
    employee
    language { create(:language) }
  end

  factory :employees_locations, class: 'Employee::EmployeesLocations' do
    employee
    location { create(:location) }
  end


  
  factory :patients_languages, class: 'Client::PatientsLanguages' do
    patient
    language { create(:language) }
  end

  factory :patients_locations, class: 'Client::PatientsLocations' do
    patient
    location { create(:location) }
  end



  factory :focusarea, class: 'Shared::Focusarea' do
    name { Faker::Job.field }
  end

  factory :language, class: 'Shared::Language' do
    name { Faker::ProgrammingLanguage.name }
  end

  factory :location, class: 'Shared::Location' do
    name { Faker::Address.city }
  end
end
```

# db/migrate/20240815103013_rename_join_tables_to_plural.rb

```rb
class RenameJoinTablesToPlural < ActiveRecord::Migration[7.1]
  def change
    rename_table :employee_focusareas, :employees_focusareas
    rename_table :employee_languages, :employees_languages
    rename_table :employee_locations, :employees_locations
    rename_table :patient_locations, :patients_locations
    rename_table :patient_languages, :patients_languages
  end
end
```

# db/migrate/20240815092615_rename_aof_to_focusarea.rb

```rb

class RenameAofToFocusarea < ActiveRecord::Migration[7.1]
  def change
    rename_table :aofs, :focusareas
    rename_column :employee_aofs, :aof_id, :focusarea_id
    rename_table :employee_aofs, :employee_focusareas
  end
end
```

# db/migrate/20240813192660_create_patient_locations.rb

```rb
class CreatePatientLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :patient_locations do |t|
      t.references :patient, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true

      t.timestamps
    end

    add_index :patient_locations, [:patient_id, :location_id], unique: true, name: 'index_patient_profile_locations_uniqueness'
  end
end
```

# db/migrate/20240813192659_create_patient_languages.rb

```rb
class CreatePatientLanguages < ActiveRecord::Migration[7.1]
  def change
    create_table :patient_languages do |t|
      t.references :patient, null: false, foreign_key: true
      t.references :language, null: false, foreign_key: true

      t.timestamps
    end

    add_index :patient_languages, [:patient_id, :language_id], unique: true, name: 'index_patient_profile_languages_uniqueness'
  end
end
```

# db/migrate/20240813192658_create_employee_locations.rb

```rb
class CreateEmployeeLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :employee_locations do |t|
      t.references :employee, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true

      t.timestamps
    end

    add_index :employee_locations, [:employee_id, :location_id], unique: true
  end
end
```

# db/migrate/20240813192657_create_employee_languages.rb

```rb
class CreateEmployeeLanguages < ActiveRecord::Migration[7.1]
  def change
    create_table :employee_languages do |t|
      t.references :employee, null: false, foreign_key: true
      t.references :language, null: false, foreign_key: true

      t.timestamps
    end

    add_index :employee_languages, [:employee_id, :language_id], unique: true
  end
end
```

# db/migrate/20240813192656_create_employee_aofs.rb

```rb
class CreateEmployeeAofs < ActiveRecord::Migration[7.1]
  def change
    create_table :employee_aofs do |t|
      t.references :employee, null: false, foreign_key: true
      t.references :aof, null: false, foreign_key: true

      t.timestamps
    end

    add_index :employee_aofs, [:employee_id, :aof_id], unique: true
  end
end
```

# db/migrate/20240813192655_create_patients.rb

```rb
class CreatePatients < ActiveRecord::Migration[7.1]
  def change
    create_table :patients do |t|
      t.string :patient_first_name, null: false
      t.string :patient_last_name, null: false
      t.date :date_of_birth, null: false
      t.integer :gender, null: false
      t.boolean :has_prescription, null: false
      t.integer :health_insurance, null: false
      t.text :diagnosis, null: false
      t.string :kita_name
      t.boolean :has_i_status
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
```

# db/migrate/20240813192654_create_clients.rb

```rb
class CreateClients < ActiveRecord::Migration[7.1]
  def change
    create_table :clients do |t|
      t.references :user, null: false, foreign_key: true
      t.string :client_first_name
      t.string :client_last_name
      t.string :address, null: false
      t.string :phone_number, null: false

      t.timestamps
    end
  end
end
```

# db/migrate/20240813192653_create_aofs.rb

```rb
class CreateAofs < ActiveRecord::Migration[7.1]
  def change
    create_table :aofs do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
```

# db/migrate/20240813192652_create_locations.rb

```rb
class CreateLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :locations do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
```

# db/migrate/20240813192651_create_languages.rb

```rb
class CreateLanguages < ActiveRecord::Migration[7.1]
  def change
    create_table :languages do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
```

# db/migrate/20240813192650_create_employees.rb

```rb
class CreateEmployees < ActiveRecord::Migration[7.1]
  def change
    create_table :employees do |t|
      t.references :user, null: false, foreign_key: true
      t.string :employee_first_name, null: false
      t.string :employee_last_name, null: false
      t.date :date_of_birth
      t.text :short_description
      t.text :long_description
      t.boolean :is_admin, default: false

      t.timestamps
    end
  end
end
```

# db/migrate/20240813191155_devise_create_users.rb

```rb
# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      # t.integer  :sign_in_count, default: 0, null: false
      # t.datetime :current_sign_in_at
      # t.datetime :last_sign_in_at
      # t.string   :current_sign_in_ip
      # t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at


      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
  end
end

```

# spec/models/user_spec.rb

```rb
require 'rails_helper'

RSpec.describe User, type: :model do
  
  describe 'valid factory check' do
    it 'has a valid factory' do
      expect(build(:user)).to be_valid
    end
  end

end
```

# spec/models/rspec_tests

```
# Test for Devise modules
describe 'Devise modules' do
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_length_of(:password).is_at_least(8) }
end

# Test for associations
describe 'associations' do
  it { is_expected.to have_one(:employee).class_name('Employee::Employee').dependent(:destroy) }
  it { is_expected.to have_one(:client).class_name('Client::Client').dependent(:destroy) }
end

# Test for user type logic
describe 'user type' do
  context 'when user is a client' do
    let(:user) { create(:user, :client) }

    it 'is associated with a client' do
      expect(user.client).to be_a(Client::Client)
    end

    it 'is not associated with an employee' do
      expect(user.employee).to be_nil
    end

    it 'returns true for client?' do
      expect(user.client?).to be true
    end

    it 'returns false for employee?' do
      expect(user.employee?).to be false
    end
  end

  context 'when user is an employee' do
    let(:user) { create(:user, :employee) }

    it 'is associated with an employee' do
      expect(user.employee).to be_a(Employee::Employee)
    end

    it 'is not associated with a client' do
      expect(user.client).to be_nil
    end

    it 'returns false for client?' do
      expect(user.client?).to be false
    end

    it 'returns true for employee?' do
      expect(user.employee?).to be true
    end
  end
end

# Test for deletion behavior
describe 'deletion behavior' do
  context 'when user is a client' do
    let!(:user) { create(:user, :client) }
    let!(:patient) { create(:patient, client: user.client) }

    it 'deletes associated client when user is deleted' do
      expect { user.destroy }.to change(Client::Client, :count).by(-1)
    end

    it 'deletes associated patients when user is deleted' do
      expect { user.destroy }.to change(Client::Patient, :count).by(-1)
    end
  end

  context 'when user is an employee' do
    let!(:user) { create(:user, :employee) }

    it 'deletes associated employee when user is deleted' do
      expect { user.destroy }.to change(Employee::Employee, :count).by(-1)
    end
  end
end

```

# spec/models/patient_spec.rb

```rb
require 'rails_helper'

RSpec.describe Client::Patient, type: :model do
  describe 'associations' do
    it { should belong_to(:client).class_name('Client::Client') }
    it { should have_many(:patients_languages).class_name('Client::PatientsLanguages') }
    it { should have_many(:languages).through(:patients_languages).class_name('Shared::Language') }
    it { should have_many(:patients_locations).class_name('Client::PatientsLocations') }
    it { should have_many(:locations).through(:patients_locations).class_name('Shared::Location') }
  end

  describe 'validations' do
    it { should validate_presence_of(:patient_first_name) }
    it { should validate_presence_of(:patient_last_name) }
    it { should validate_presence_of(:date_of_birth) }
    it { should validate_presence_of(:gender) }
    it { should validate_presence_of(:health_insurance) }
    it { should validate_presence_of(:diagnosis) }
    it { should validate_inclusion_of(:has_prescription).in_array([true, false]) }
  end

  describe 'enums' do
    it { should define_enum_for(:gender).with_values(male: 0, female: 1, other: 2) }
    it { should define_enum_for(:health_insurance).with_values(publicly: 0, privately: 1) }
  end

  describe 'custom validations' do
    it 'should not allow date_of_birth in the future' do
      patient = build(:patient, date_of_birth: Date.tomorrow)
      expect(patient).not_to be_valid
      expect(patient.errors[:date_of_birth]).to include("can't be in the future")
    end
  end
end
```

# spec/models/employee_spec.rb

```rb
require 'rails_helper'

RSpec.describe Employee::Employee, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:employees_focusareas).class_name('Employee::EmployeesFocusarea') }
    it { should have_many(:focusareas).through(:employees_focusareas).class_name('Shared::Focusarea') }
    it { should have_many(:employees_languages).class_name('Employee::EmployeesLanguage') }
    it { should have_many(:languages).through(:employees_languages).class_name('Shared::Language') }
    it { should have_many(:employees_locations).class_name('Employee::EmployeesLocation') }
    it { should have_many(:locations).through(:employees_locations).class_name('Shared::Location') }
  end

  describe 'validations' do
    it { should validate_presence_of(:employee_first_name) }
    it { should validate_presence_of(:employee_last_name) }
    it { should validate_presence_of(:date_of_birth) }
  end

  describe 'custom validations' do
    it 'should not allow date_of_birth in the future' do
      employee = build(:employee, date_of_birth: Date.tomorrow)
      expect(employee).not_to be_valid
      expect(employee.errors[:date_of_birth]).to include("can't be in the future")
    end
  end
end
```

# spec/models/client_spec.rb

```rb
require 'rails_helper'

RSpec.describe Client::Client, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:patients).class_name('Client::Patient').dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:phone_number) }
    it { should allow_value('+1 (123) 456-7890').for(:phone_number) }
    it { should_not allow_value('invalid phone').for(:phone_number) }
  end
end
```

# app/policies/application_policy.rb

```rb
# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NoMethodError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope
  end
end

```

# app/models/user.rb

```rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :employee, class_name: 'Employee::Employee', dependent: :destroy
  has_one :client, class_name: 'Client::Client', dependent: :destroy

  def employee?
    employee.present?
  end

  def client?
    client.present?
  end
end

```

# app/models/application_record.rb

```rb
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end

```

# app/jobs/application_job.rb

```rb
class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError
end

```

# app/javascript/application.js

```js
// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

```

# app/helpers/application_helper.rb

```rb
module ApplicationHelper
end

```

# app/controllers/application_controller.rb

```rb
class ApplicationController < ActionController::Base
  before_action :set_locale

  private

  def set_locale
    I18n.locale = :de
  end
end

```

# app/mailers/application_mailer.rb

```rb
class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"
end

```

# test/fixtures/files/.keep

```

```

# test/channels/application_cable/connection_test.rb

```rb
require "test_helper"

module ApplicationCable
  class ConnectionTest < ActionCable::Connection::TestCase
    # test "connects with cookies" do
    #   cookies.signed[:user_id] = 42
    #
    #   connect
    #
    #   assert_equal connection.user_id, "42"
    # end
  end
end

```

# app/views/layouts/mailer.text.erb

```erb
<%= yield %>

```

# app/views/layouts/mailer.html.erb

```erb
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <style>
      /* Email styles need to be inline */
    </style>
  </head>

  <body>
    <%= yield %>
  </body>
</html>

```

# app/views/layouts/application.html.erb

```erb
<!DOCTYPE html>
<html>
  <head>
    <title>RailsLogopaediebreula</title>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>

    <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
    <%= javascript_include_tag "application", "data-turbo-track": "reload", type: "module" %>
  </head>

  <body>
    <%= yield %>
  </body>
</html>

```

# app/models/concerns/.keep

```

```

# app/models/shared/location.rb

```rb
module Shared
  class Location < ApplicationRecord
    has_many :employee_locations, class_name: 'Employee::EmployeesLocations'
    has_many :employees, through: :employee_locations, class_name: 'Employee::Employee'
    has_many :patient_locations, class_name: 'Client::PatientsLocations'
    has_many :patients, through: :patient_locations, class_name: 'Client::Patient'

    validates :name, presence: true, uniqueness: true
  end
end

```

# app/models/shared/language.rb

```rb
module Shared
  class Language < ApplicationRecord
    has_many :employee_languages, class_name: 'Employee::EmployeesLanguages'
    has_many :employees, through: :employee_languages, class_name: 'Employee::Employee'
    has_many :patient_languages, class_name: 'Client::PatientsLanguages'
    has_many :patients, through: :patient_languages, class_name: 'Client::Patient'

    validates :name, presence: true, uniqueness: true
  end
end
```

# app/models/shared/focusarea.rb

```rb
module Shared
  class Focusarea < ApplicationRecord
    has_many :employees_focusareas, class_name: 'Employee::EmployeesFocusareas'
    has_many :employees, through: :employee_focusareas, class_name: 'Employee::Employee'

    validates :name, presence: true, uniqueness: true
  end
end
```

# app/models/employee/employees_locations.rb

```rb
class Employee::EmployeesLocations < ApplicationRecord
  belongs_to :employee, class_name: 'Employee::Employee'
  belongs_to :location, class_name: 'Shared::Location'

  validates :employee_id, uniqueness: { scope: :location_id }
end
```

# app/models/employee/employees_languages.rb

```rb
class Employee::EmployeesLanguages < ApplicationRecord
  belongs_to :employee, class_name: 'Employee::Employee'
  belongs_to :language, class_name: 'Shared::Language'

  validates :employee_id, uniqueness: { scope: :language_id }
end
```

# app/models/employee/employees_focusareas.rb

```rb
class Employee::EmployeesFocusareas < ApplicationRecord
  belongs_to :employee, class_name: 'Employee::Employee'
  belongs_to :focusarea, class_name: 'Shared::Focusarea'

  validates :employee_id, uniqueness: { scope: :focusarea_id }
end
```

# app/models/employee/employee.rb

```rb
module Employee
end

class Employee::Employee < ApplicationRecord
  belongs_to :user
  has_many :employee_focusareas, class_name: 'Employee::EmployeeFocusarea'
  has_many :focusareas, through: :employee_focusareas, class_name: 'Shared::Focusarea'
  has_many :employee_languages, class_name: 'Employee::EmployeeLanguage'
  has_many :languages, through: :employee_languages, class_name: 'Shared::Language'
  has_many :employee_locations, class_name: 'Employee::EmployeeLocation'
  has_many :locations, through: :employee_locations, class_name: 'Shared::Location'

  validates :employee_first_name, presence: true
  validates :employee_last_name, presence: true
  validates :date_of_birth, presence: true
  validate :date_of_birth_not_in_future

  private

  def date_of_birth_not_in_future
    return unless date_of_birth.present? && date_of_birth > Date.today
    errors.add(:date_of_birth, "can't be in the future")
  end
end

```

# app/javascript/controllers/index.js

```js
// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import HelloController from "./hello_controller"
application.register("hello", HelloController)

```

# app/javascript/controllers/hello_controller.js

```js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.textContent = "Hello World!"
  }
}

```

# app/javascript/controllers/application.js

```js
import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }

```

# app/models/client/patients_locations.rb

```rb
class Client::PatientsLocations < ApplicationRecord
  belongs_to :patient, class_name: 'Client::Patient'
  belongs_to :location, class_name: 'Shared::Location'

  validates :patient_id, uniqueness: { scope: :location_id }
end
```

# app/models/client/patients_languages.rb

```rb
class Client::PatientsLanguages < ApplicationRecord
  belongs_to :patient, class_name: 'Client::Patient'
  belongs_to :language, class_name: 'Shared::Language'

  validates :patient_id, uniqueness: { scope: :language_id }
end
```

# app/models/client/patient.rb

```rb
class Client::Patient < ApplicationRecord
  belongs_to :client, class_name: 'Client::Client'
  has_many :patient_languages, class_name: 'Client::PatientLanguage'
  has_many :languages, through: :patient_languages, class_name: 'Shared::Language'
  has_many :patient_locations, class_name: 'Client::PatientLocation'
  has_many :locations, through: :patient_locations, class_name: 'Shared::Location'

  enum gender: { male: 0, female: 1, other: 2 }
  enum health_insurance: { publicly: 0, privately: 1 }

  validates :patient_first_name, presence: true
  validates :patient_last_name, presence: true
  validates :date_of_birth, presence: true
  validates :gender, presence: true
  validates :has_prescription, inclusion: { in: [true, false] }
  validates :health_insurance, presence: true
  validates :diagnosis, presence: true
  validate :date_of_birth_not_in_future

  private

  def date_of_birth_not_in_future
    return unless date_of_birth.present? && date_of_birth > Date.today
    errors.add(:date_of_birth, "can't be in the future")
  end
end
```

# app/models/client/client.rb

```rb
module Client
end

class Client::Client < ApplicationRecord
  belongs_to :user
  has_many :patients, class_name: 'Client::Patient', dependent: :destroy

  validates :user, presence: true
  validates :address, presence: true
  validates :phone_number, presence: true, format: { with: /\A\+?[\d\s()-]+\z/, message: 'invalid format' }
end
```

# app/channels/application_cable/connection.rb

```rb
module ApplicationCable
  class Connection < ActionCable::Connection::Base
  end
end

```

# app/channels/application_cable/channel.rb

```rb
module ApplicationCable
  class Channel < ActionCable::Channel::Base
  end
end

```

# app/assets/stylesheets/application.tailwind.css

```css
@tailwind base;
@tailwind components;
@tailwind utilities;

```

# app/assets/images/.keep

```

```

# app/controllers/concerns/.keep

```

```

