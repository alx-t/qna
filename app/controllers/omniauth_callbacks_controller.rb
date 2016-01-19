class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :provider_callback, only: [:facebook, :twitter, :finish_registration]

  def facebook
  end

  def twitter
  end

  def finish_registration
  end

  private

  def provider_callback
    #render json: request.env['omniauth.auth']
    @user = User.find_for_oauth(auth)
    if @user && @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
    else
      flash[:notice] = 'Email is required to finish registration'
      render 'omniauth_callbacks/add_email', locals: { auth: auth }
    end
  end

  def auth
    request.env['omniauth.auth'] || OmniAuth::AuthHash.new(params[:auth])
  end
end

