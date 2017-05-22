require 'jwt_wrapper'
class BasicAuthStrategy < ::Warden::Strategies::Base
  def auth
    @auth ||= Rack::Auth::Basic::Request.new(env)
  end

  def valid?
    auth.provided? && auth.basic? && request.env['HTTP_AUTHORIZATION'].present?
  end

  def authenticate!
    params = JWTWrapper.first_decode(request.env['HTTP_AUTHORIZATION'].gsub('Basic ', ''))

    user = User.find_by_email_or_username(params["username"])
    if user && user.authenticate(params["password"])
      success!(user)
    else
      fail!('strategies.basic_auth.failed')
    end
  end
end
