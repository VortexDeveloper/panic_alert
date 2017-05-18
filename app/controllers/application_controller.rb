class ApplicationController < ActionController::API
  include ActionController::Helpers
  include WardenHelper

  def home
    render json: {text: 'Olá'}
  end
end
