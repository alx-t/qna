module ControllerIncludeMacros
  def log_in(user)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  end
end
