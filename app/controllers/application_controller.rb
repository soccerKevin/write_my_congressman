class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_paper_trail_whodunnit


  alias :devise_current_user :current_user
   # if user is logged in, return current_user, else return guest_user
  def current_user
    if devise_current_user
      if session[:guest_user_id] && session[:guest_user_id] != devise_current_user.id
        logging_in
        # reload guest_user to prevent caching problems before destruction
        guest_user(with_retry = false).reload.try(:destroy)
        session[:guest_user_id] = nil
      end
      devise_current_user
    else
      guest_user
    end
  end

  # find guest_user object associated with the current session,
  # creating one as needed
  def guest_user(with_retry = true)
    # Cache the value the first time it's gotten.
    @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)

  rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
     session[:guest_user_id] = nil
     guest_user if with_retry
  end

  private

  # called (once) when the user logs in, insert any code your application needs
  # to hand off from guest_user to devise_current_user.
  def logging_in
    guest_messages = guest_user.messages.all
    guest_messages.each do |message|
      message.user_id = devise_current_user.id
      message.save!
    end
    devise_current_user.guest = false
    devise_current_user.save! validate: false
  end

  def create_guest_user
    u = User.create name: "guest", email: "guest_#{Time.now.to_i}#{rand(100)}@example.com", guest: true
    u.save! validate: false
    session[:guest_user_id] = u.id
    u
  end

  def after_sign_in_path_for(resource)
    if resource.is_a? User
      user = resource
      new_message_path
    end
  end
end
