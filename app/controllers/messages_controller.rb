class MessagesController < ApplicationController
  layout 'message'

  def new
    @user = current_user || User.new
    @message = @user.messages.build
    @user.address || @user.build_address
    @legislators = @user.legislators.reject{ |l| %w{trump pence}.include? l.last_name.downcase }
  end

  helper_method def placeholders
    @placeholders = {
      name: current_user&.name || true,
      email: current_user&.email || true,
      address_line: current_user&.address&.line || 'Address',
      city: current_user&.address&.city || true,
      state: current_user&.address&.state || true,
      zip: current_user&.address&.zip || true,
      subject: true,
      body: true
    }
  end
end
