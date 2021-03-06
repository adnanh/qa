require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Qa
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    I18n.enforce_available_locales = false
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en

    # appwide constants
    config.USER_PRIV = 1
    config.ADMIN_PRIV = 2
    config.PAGE_SIZE = 10

    #karma
    config.KARMA_ACCEPTED_ANSWER_POINTS = 15
    config.KARMA_UNACCEPTED_ANSWER_POINTS = -15
    config.KARMA_UPVOTE_POINTS = 2
    config.KARMA_DOWNVOTE_POINTS = -2
  end
end
