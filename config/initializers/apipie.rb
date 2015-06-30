Apipie.configure do |config|
  config.app_name                = "EdenAPI"
  config.api_base_url            = ""
  config.doc_base_url            = "/documentation"
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/*.rb"
  config.validate = false
end
