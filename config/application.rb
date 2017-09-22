require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MintRocketAdmin
	class Application < Rails::Application
		config.autoload_paths += %W(#{config.root}/lib)

		## DEFAULT
		config.active_record.raise_in_transactional_callbacks = true

		## FOR i18n
		config.i18n.default_locale = :ru
		config.i18n.locale = 'ru'
		config.i18n.enforce_available_locales = false
		config.i18n.available_locales = :ru
		config.i18n.load_path += Dir[Rails.root.join('config', 'locales', 'models', '**', '*.{rb,yml}')]
	end

	class Api < Rails::Application
		## FOR API
		config.middleware.use ActionDispatch::Flash
		config.api_only = false

		## FOR PAGINATION
		config.paginator = :will_paginate #:kaminari or :will_paginate
		config.total_header = 5 # By default, this is set to 'Total'
		config.per_page_header = 25 # By default, this is set to 'Per-Page'
	end
end
