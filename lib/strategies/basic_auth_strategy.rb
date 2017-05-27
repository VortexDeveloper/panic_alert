require 'jwt_wrapper'
require_relative 'strategies_helper.rb'

class BasicAuthStrategy < ::Warden::Strategies::Base
  include StrategiesHelper

  def valid?
    auth.provided? #&& auth.basic? && request.env['HTTP_AUTHORIZATION'].present?
  end

  def authenticate!
    params = token_decoded('Basic')
    params ||= token_decoded('Bearer')

    byebug

    user = User.find_by_email_or_username(params["username"])

    return success!(user) if user && user.authenticate(params["password"])
    fail!('strategies.basic_auth.failed')
  end
end
