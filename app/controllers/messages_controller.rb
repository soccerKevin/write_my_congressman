class MessagesController < ApplicationController
  layout 'message'

  def new
    @user = current_user
    @message = @user.messages.build
    @user.address || @user.build_address
    @legislators = @user.legislators
  end
end
