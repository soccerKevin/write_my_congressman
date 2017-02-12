class UsersController < ApplicationController
  def edit
    @user = current_user
    @user.address || @user.build_address
  end

  def update
    current_user.update! user_params
<<<<<<< HEAD
    redirect_to 'legislators'
=======
    redirect_to '/legislators'
>>>>>>> a879d437cf869a79946b316f4e80ec521dd8de22
  rescue Exception => e
    render action: :edit
  end

private
  def user_params
    params.require(:user).permit(address_attributes: [:line, :city, :state, :zip])
  end
end
