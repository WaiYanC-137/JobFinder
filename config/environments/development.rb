Rails.application.configure do
  # Basic configuration for development environment
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  config.active_storage.service = :local
  # Enable full error reports and disable caching
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false

  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              'smtp.gmail.com',
    port:                 587,
    domain:               'example.com',
    user_name:            'aungmyintmo.kzy@gmail.com',
    password:             'losvotoisnhjxigf',
    authentication:       'plain',
    enable_starttls_auto: true,
    openssl_verify_mode:  'none'
  }
  
  
  
  # Other necessary development configurations
end
