class NotificationsController < ApplicationController
  include NotificationHelper

  before_action :authenticate!

  def index
    notifications = current_user.notifications.order(created_at: :desc)
    render json: { notifications: notifications }
  end

  def create
    targets = current_user.accepted_dependent_requests
    if targets.present?
      add_to_payload = {
        position: {
          latitude: params[:notifications][:position][:coords][:latitude],
          longitude: params[:notifications][:position][:coords][:longitude],
          accuracy: params[:notifications][:position][:coords][:accuracy]
        },
        kind: params[:notifications][:kind],
        hour: DateTime.now.in_time_zone.to_s,
        sender_name: current_user.name
      }
      message = "#{current_user.name} está pedindo sua ajuda"
      send_notification_to(
        current_user.accepted_dependent_requests,
        message,
        add_to_payload,
        params[:notifications][:kind]
      )

      head :no_content
    else
      render json: {errors: {message: "Você ainda não possui contatos de emergência!"}}, status: :unprocessable_entity
    end

  end

  def update
    @notification_user = NotificationUser.find_by_user_and_code(current_user, params[:code])
    @notification_user.received!
  end

  private

  def notifications_params
    params.require(:notifications).permit(
      :message,
      :options
    )
  end

  def send_notification_to(contacts, message, add_to_payload, kind)
    notification_code = DateTime.now.to_s :for_code
    device_tokens = contacts.map(&:device_token).compact
    notification_options = {
      tokens: device_tokens || [],
      message: message,
      title: "Pânico do Alerta",
      "force-start": 1,
      payload: {
        data: {
          title: "Pânico do Alerta",
          'content-available': '1',
          notId: notification_code,
          soundname: 'panic_scream',
          ledColor: [255, 0, 0, 0],
          image: 'https://dl.dropboxusercontent.com/u/887989/antshot.png',
          'image-type': 'circle'
        }
      }
    }

    notification_options[:payload][:data].merge!(add_to_payload)

    notification = IonicNotification::Notification.new(notification_options)
    notification.send if device_tokens.present?
    save_user_notification(notification, contacts, kind, notification_code)
  end
end
