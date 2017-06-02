class NotificationsController < ApplicationController
  before_action :authenticate!

  def create
    device_tokens = current_user.accepted_dependent_requests.map do |u|
      u.device_token if u.device_token.present?
    end
    byebug
    notification = IonicNotification::Notification.new(
      tokens: device_tokens,
      message: notifications_params[:message],
      title: "Alerta de Pânico"
    )
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
