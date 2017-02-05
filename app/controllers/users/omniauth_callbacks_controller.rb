class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def twitter
    oauth
  end

  def facebook
    oauth
  end

  def google_oauth2
    oauth
  end

private

  def oauth
    auth_params = request.env["omniauth.auth"]
    provider = AuthenticationProvider.where(name: auth_params.provider).first
    authentication = provider.user_authentications.where(uid: auth_params.uid).first
    existing_user = current_user || User.where('email = ?', auth_params['info']['email']).first
    user_name existing_user, auth_params['info']

    if authentication
      sign_in_with_existing_authentication authentication
    elsif existing_user
      create_authentication_and_sign_in auth_params, existing_user, provider
    else
      create_user_and_authentication_and_sign_in auth_params, provider
    end
  end

  def user_name(user, info)
    return if user.first_name.present? && user.last_name.present?
    user.first_name = info['first_name'] if info['first_name'].present?
    user.last_name = info['last_name'] if info['last_name'].present?
    user.save!
  end

  def sign_in_with_existing_authentication(authentication)
    sign_in_and_redirect :user, authentication.user
  end

  def create_authentication_and_sign_in(auth_params, user, provider)
    UserAuthentication.create_from_omniauth auth_params, user, provider

    sign_in_and_redirect :user, user
  end

  def create_user_and_authentication_and_sign_in(auth_params, provider)
    user = User.create_from_omniauth auth_params
    if user.valid?
      create_authentication_and_sign_in auth_params, user, provider
    else
      flash[:error] = user.errors.full_messages.first
      redirect_to new_user_registration_url
    end
  end
end
