class UsersController < ApplicationController
  def edit
    @user = current_user
    @user.address || @user.build_address
  end

  def update
    current_user.update! user_params
    redirect_to new_message_path
  rescue Exception => e
    render action: :edit
  end

private
  def user_params
    params.require(:user).permit(address_attributes: [:line, :city, :state, :zip])
  end
end
