Apipie.configure do |config|
  config.app_name                = "ventimperia"
  config.api_base_url            = "/api"
  config.doc_base_url            = "/api_doc"
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/**/*.rb"
end
