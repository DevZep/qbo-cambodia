
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'support/factory_girl'
require 'capybara/rspec'
require 'shoulda/matchers'
require 'capybara/poltergeist'
require 'vcr_config'

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  config.include Devise::TestHelpers, :type => :controller

  config.include Warden::Test::Helpers

  # config.before(type: :feature) do
  #   allow_any_instance_of(Browser::Generic).to receive(:modern?) { true }
  # end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

 config.before(:suite) do
    DatabaseCleaner.clean_with :truncation
  end

 config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

 config.before(:each, js: true) do
    # page.driver.browser.url_whitelist = ['https://appcenter.intuit.com']

    DatabaseCleaner.strategy = :truncation
  end

 config.before(:each) do
    DatabaseCleaner.start
  end

 config.after(:each) do
    DatabaseCleaner.clean
  end

end

Capybara.javascript_driver = :poltergeist
Capybara.register_driver :poltergeist do |app|
  options = {
    # js_errors: false,
    phantomjs_options: ['--load-images=false', '--ignore-ssl-errors=yes']
  }
  Capybara::Poltergeist::Driver.new(app, options)
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end