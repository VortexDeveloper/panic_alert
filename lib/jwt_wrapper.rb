require 'jwt'
module JWTWrapper
  extend self

  def encode(payload, expiration = nil)
    expiration ||= Rails.application.secrets.jwt_expiration_hours

    payload = payload.dup
    payload['exp'] = expiration.to_i.hours.from_now.to_i

    JWT.encode payload, Rails.application.secrets.jwt_secret
  end

  def decode(token)
    begin
      decoded_token = JWT.decode token, Rails.application.secrets.jwt_secret
      decoded_token.first
    rescue => e
      puts e
    end
  end

  def first_decode(token)
    begin
      decoded_token = JWT.decode token, nil, false
      decoded_token.first
    rescue => e
      puts e
    end
  end
end
