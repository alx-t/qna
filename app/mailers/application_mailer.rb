class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.secrets.email_user_from
  layout nil
end
