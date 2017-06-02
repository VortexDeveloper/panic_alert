class NotificationsController < ApplicationController
  before_action :authenticate!

  def create
    device_tokens = current_user.accepted_dependent_requests.map do |u|
      u.device_token if u.device_token.present?
    end
    notification = IonicNotification::Notification.new(
      tokens: device_tokens,
      message: "Está pedindo sua ajuda",
      title: "Pânico do Alerta | #{current_user.name}",
      "force-start": 1,
      payload: {
        data: {
          title: "Pânico do Alerta | #{current_user.name}",
          body: "Está pedindo sua ajuda",
          notId: 10,
          'content-available': '1'
        }
      }
    )

    head :no_content
  end

  private

  def notifications_params
    params.require(:notifications).permit(
      :message,
      :options
    )
  end
end
