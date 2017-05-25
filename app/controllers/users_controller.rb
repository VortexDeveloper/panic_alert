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

  def after_sign_in_do
    render json: {authentication_token: JWT.encode(current_user.authentication_token, nil, false), user: current_user.as_json}
  end

  def send_support_email
    begin
      UserMailer.send_support_email(current_user, params[:message]).deliver
      head :no_content
    rescue => e
      render json: e.message, status: 422
    end
  end

  private
  def user_params
    params.require(:user).permit(
      :name,
      :username,
      :email,
      :password,
      :password_confirmation
    )
  end
end
