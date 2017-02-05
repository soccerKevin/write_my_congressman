class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

private
  def after_sign_in_path_for(resource)
    if resource.is_a? User
      user = resource
      if user.address.present?
        legislators_path
      else
        edit_user_path user
      end
    end
  end
end
