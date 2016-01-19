module Omniauthable
  extend ActiveSupport::Concern

  included do
    has_many :authorizations, dependent: :destroy
  end

  class_methods do
    def find_for_oauth(auth)
      authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
      return authorization.user if authorization

      if auth.info.try(:email)
        email = auth.info[:email]
      else
        return false
      end

      user = User.where(email: email).first
      if user
        user.create_authorization(auth)
      else
        password = Devise.friendly_token[0, 20]
        user = User.create!(email: email, password: password, password_confirmation: password)
        user.create_authorization(auth)
      end
      user
    end
  end

  def create_authorization(auth)
      self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end

