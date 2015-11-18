require 'rails_helper'

require 'capybara/poltergeist'

RSpec.configure do |config|
  config.include AcceptanceHelpers, type: :feature

  config.use_transactional_fixtures = false

  Capybara.javascript_driver = :poltergeist

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
