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
      payload: {
        data: {
          title: "Test Notification",
          body: "This offer expires at 11:30 or whatever",
          notId: 10,
          content_available: true,
          surveyID: "ewtawgreg-gragrag-rgarhthgbad"
        }
      }
    )
    logger.info "[NOTIFIER] #{notification.as_json}"
    notification.send

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
