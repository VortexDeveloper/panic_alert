class UnauthorizedController < ActionController::Metal

  def self.call(env)
    @respond ||= action(:respond)
    @respond.call(env)
  end

  def respond
    self.status = 401
    self.content_type = "application/json"
    self.response_body = [ { message: "Login ou senha inválidos, por favor tente novamente." } ].to_json
  end
end
