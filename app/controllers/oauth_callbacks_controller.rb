class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    oauth('github')
  end

  def vkontakte
    oauth('vkontakte')
  end

  def oauth(provider)
    auth_data = request.env['omniauth.auth']

    @user = User.find_for_oauth(auth_data)

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    elsif auth_data && auth_data[:provider] && auth_data[:uid]
      session[:provider] = auth_data[:provider]
      session[:uid] = auth_data[:uid]&.to_s

      render 'user/send_email/new'
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
