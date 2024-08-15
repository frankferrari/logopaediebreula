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
