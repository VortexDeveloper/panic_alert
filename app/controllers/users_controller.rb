class UsersController < ApplicationController
  before_action :authenticate!, except: [:login]

  def login
    sign_in
  end

  def logout
    sign_out
  end

  def after_sign_in_do
    render json: {authentication_token: current_user.authentication_token, user: current_user.as_json}
  end
end
