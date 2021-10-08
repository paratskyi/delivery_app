require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/cuprite'

Capybara.register_driver :cuprite_headless do |app|
  Capybara::Cuprite::Driver.new(app, {
    js_errors: true,
    window_size: [1440, 1080],
    process_timeout: 10, # fix for macOS chrome
    timeout: 10, # to fix some rare cases on local machine
    # https://peter.sh/experiments/chromium-command-line-switches/
    browser_options: {
      'disable-gpu' => nil,
      'no-sandbox' => nil,
      'disable-setuid-sandbox' => nil,
      'start-maximized' => nil

    }
  })
end

Capybara.register_driver :cuprite do |app|
  Capybara::Cuprite::Driver.new(app, {
    js_errors: true,
    window_size: [1440, 1080],
    process_timeout: 10, # fix for macOS chrome
    timeout: 10, # to fix some rare cases on local machine
    # https://peter.sh/experiments/chromium-command-line-switches/
    browser_options: {
      'disable-gpu' => nil,
      'no-sandbox' => nil,
      'disable-setuid-sandbox' => nil,
      'start-maximized' => nil
    }

  })
end

Capybara.javascript_driver = ENV['JS_DRIVER'].presence&.to_sym || :cuprite_headless

RSpec.configure do |config|
  config.before(:each, type: :system, js: true) do
    driven_by Capybara.javascript_driver
  end
end
