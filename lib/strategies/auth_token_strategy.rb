class AuthTokenStrategy < ::Warden::Strategies::Base
  def valid?
    authentication_token
  end

  def authenticate!
    user = User.find_by_authentication_token(authentication_token)
    user.nil? ? fail!('strategies.authentication_token.failed') : success!(user)
  end

  private
  def authentication_token
    # request.headers['Authorization'].present?
    params['authentication_token']
  end
end
