module WardenHelper
  extend ActiveSupport::Concern

  included do
    helper_method :warden, :signed_in?, :current_user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user
    warden.user
  end

  def warden
    request.env['warden']
  end

  def authenticate!
    warden.authenticate!
  end

  def after_sign_in_do
    render json: current_user.as_json
  end

  def sign_in
    if authenticate!
      after_sign_in_do
    else
      render json: {errors: { message: "Unauthorized Credentials" }}
    end
  end

  def sign_out
    if signed_in?
      current_user.logout
    end
  end
end
