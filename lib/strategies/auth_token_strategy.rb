require_relative 'strategies_helper.rb'

class AuthTokenStrategy < ::Warden::Strategies::Base
  include StrategiesHelper

  def valid?
    auth.provided? #&& !auth.basic? && headers['HTTP_AUTHORIZATION'].start_with?('Bearear')
  end

  def authenticate!
    auth = authentication_token

    if auth.nil?
      auth = token_decoded('Basic')
      user = User.find_by_email_or_username(auth["username"])

      return success!(user) if user && user.authenticate(auth["password"])
      fail!('strategies.basic_auth.failed')
    else
      user = User.find_by_authentication_token(auth['token'])
      user.nil? ? fail!('strategies.authentication_token.failed') : success!(user)
    end
  end

  private
  def authentication_token
    return params['authentication_token'] if params['authentication_token'].present?
    token_decoded('Bearer')
  end
end
