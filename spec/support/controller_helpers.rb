module ControllerHelpers
  extend ActiveSupport::Concern
  include Devise::Test::ControllerHelpers

  def login_user
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = users :user
    sign_in @user
  end

  def login_user_with_address
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = users :user_with_address
    sign_in @user
  end
end
