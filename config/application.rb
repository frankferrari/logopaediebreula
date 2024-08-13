require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsLogopaediebreula
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    
    config.autoload_lib(ignore: %w(assets tasks))

    config.autoload_paths += %W(
      #{config.root}/app/models/shared
      #{config.root}/app/models/employee
      #{config.root}/app/models/client
    )
    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    config.time_zone = 'Berlin'

    # Set default locale to German
    config.i18n.default_locale = :de
    config.i18n.available_locales = [:de]

    # Use default German locale settings for date, time, and number formatting
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
  end
end
 