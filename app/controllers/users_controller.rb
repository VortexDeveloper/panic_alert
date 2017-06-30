class UsersController < ApplicationController
  before_action :authenticate!, except: [:login, :sign_up]

  def login
    sign_in
  end

  def logout
    sign_out
  end

  def sign_up
    @user = User.new(user_params)

    if @user.save
      warden.set_user @user
      sign_in
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def send_support_email
    begin
      UserMailer.send_support_email(current_user, params[:message]).deliver
      head :no_content
    rescue => e
      render json: e.message, status: 422
    end
  end

  def after_sign_in_do
    render json: {
      authentication: JWT.encode({token: current_user.authentication_token}, nil, false),
      user: current_user.as_json
    }
  end

  def save_notification_token
    token_params = notification_token_params

    if token_params[:registered]
      current_user.device_token = token_params[:token]
      current_user.device_type = token_params[:type]
      current_user.save

      head :no_content
    else
      render json: current_user.errors, status: 422
    end
  end

  def my_help_requests
    @help_requests = current_user.my_help_requests
  end

  private

  def notification_token_params
    params.require(:user).permit(
      :token,
      :type,
      :registered
    )
  end

  def user_params
    params.require(:user).permit(
      :name,
      :username,
      :email,
      :phone_number,
      :ddd,
      :password,
      :password_confirmation
    )
  end
end
