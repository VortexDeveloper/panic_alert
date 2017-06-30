class NotificationsController < ApplicationController
  include NotificationHelper

  before_action :authenticate!

  def index
    notifications = current_user.received_notifications.order(created_at: :desc)
    render json: { notifications: notifications }
  end

  def create
    targets = current_user.accepted_dependent_requests
    if targets.present?
      message = "#{current_user.name} está pedindo sua ajuda"
      add_to_payload = notification_options(message)

      send_notification_to targets, add_to_payload
      head :no_content
    else
      render json: {errors: {message: "Você ainda não possui contatos de emergência!"}}, status: :unprocessable_entity
    end
  end

  def update
    @notification_user = NotificationUser.find_by_destiny_and_code(current_user, params[:code])
    @notification_user.received!
  end

  private

  def notifications_params
    params.require(:notifications).permit(
      :message,
      :options
    )
  end

  def notification_options(message)
    notification_options = {
      message: message,
      "force-start": 1,
      payload: {
        data: {
          body: message,
          'content-available': '1',
          soundname: 'panic_scream',
          ledColor: [255, 0, 0, 0],
          image: 'https://dl.dropboxusercontent.com/u/887989/antshot.png',
          'image-type': 'circle',
          position: {
            latitude: params[:notifications][:position][:coords][:latitude],
            longitude: params[:notifications][:position][:coords][:longitude],
            accuracy: params[:notifications][:position][:coords][:accuracy]
          },
          kind: params[:notifications][:kind],
          hour: DateTime.now.in_time_zone.to_s,
          sender_name: current_user.name
        }
      }
    }
  end
end
