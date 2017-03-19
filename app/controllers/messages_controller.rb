class MessagesController < ApplicationController
  before_action :require_user_address
  layout 'message'

  def new
    @user = current_user || User.new
    @message = @user.messages.build
    @user.address || @user.build_address
    @legislators = @user.legislators.reject{ |l| %w{trump pence}.include? l.last_name.downcase }
  end

  helper_method def defaults
    @defaults = {
      name: current_user&.name,
      email: current_user&.email,
      address_line: current_user&.address&.line,
      city: current_user&.address&.city,
      state: current_user&.address&.state,
      zip: current_user&.address&.zip,
      subject: nil,
      body: nil
    }
  end

private
  def require_user_address
    if current_user.present? && current_user.address.blank?
      redirect_to edit_user_path current_user
    end
  end
end
