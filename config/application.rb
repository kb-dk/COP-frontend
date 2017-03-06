require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module COPFrontendNew
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    I18n.available_locales = [:en, :da]

    # Setting da as default language
    config.i18n.enforce_available_locales = true
    config.i18n.default_locale = :da

  end
end
