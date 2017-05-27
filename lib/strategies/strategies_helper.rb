module StrategiesHelper
  def auth
    @auth ||= Rack::Auth::Basic::Request.new(env)
  end

  def token_decoded(key)
    JWTWrapper.first_decode(request.env['HTTP_AUTHORIZATION'].gsub("#{key} ", ''))
  end

  def headers
    auth.request.env.select { |k,v| k if k.start_with? 'HTTP_' }
  end
end
