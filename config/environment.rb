# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.default_url_options[:host] = Rails.application.secrets.email_host
ActionMailer::Base.smtp_settings = {
  address: Rails.application.secrets.email_address,
  port: 587,
  user_name: Rails.application.secrets.email_user_name,
  password: Rails.application.secrets.email_user_password,
  authentication: :plain,
  enable_starttls_auto: true,
  openssl_verify_mode: "none"
}

