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
Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }
# Explicitly require factory files
loaded_factories = Set.new
Dir[Rails.root.join('spec/factories/**/*.rb')].each do |f|
  unless loaded_factories.include?(File.basename(f))
    require f
    loaded_factories.add(File.basename(f))
  end
end

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
