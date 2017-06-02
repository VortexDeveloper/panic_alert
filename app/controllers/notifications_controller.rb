class NotificationsController < ApplicationController
  before_action :authenticate!

  def create
    notification = IonicNotification::Notification.new(
      tokens: current_user.accepted_dependent_requests.map(&:device_token),
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
