class MessagesController < ApplicationController
  before_action :require_user_address
  layout 'message'

  def new
    render_message
  end

  def edit
    render_message message: Message.find(params[:id])
  end

  def create
    @message = Message.new message_params
    @message.save ? thank_you : render_message(@message)
  end

  def thank_you
    render 'messages/thank_you'
  end

  def address
    a = message_params
    a[:line] = a.delete :address_line
    address = Address.new a

    if address.valid?
      legislators = address.legislators
      return render json: legislators.to_json, status: 200 if legislators.length > 0
    end

    render json: { errors: @model.errors.full_messages }
  end

private

  def message_params
    pars = params.require(:message).permit :name, :email, :address_line, :city, :state, :zip, :subject, :body, :legislator_ids
    pars[:legislator_ids] = pars[:legislator_ids].split(',') if pars[:legislator_ids]
    pars
  end

  def render_message(message: nil)
    @user = current_user || User.new
    @user.address || @user.build_address
    message ||= @user.messages.build
    @message = message
    @legislators = @user.legislators.reject{ |l| %w{trump pence}.include? l.last_name.downcase }
  end

  def require_user_address
    if current_user.present? && current_user.address.blank?
      redirect_to edit_user_path current_user
    end
  end
end
