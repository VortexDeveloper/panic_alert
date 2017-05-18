class UnauthorizedController < ActionController::Metal

  def self.call(env)
    @respond ||= action(:respond)
    @respond.call(env)
  end

  def respond
    self.status = 401
    self.content_type = "application/json"
    self.response_body = [ { message: "Unauthorized Credentials" } ].to_json
  end
end
