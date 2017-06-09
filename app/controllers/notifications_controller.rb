class NotificationsController < ApplicationController
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

  private

  def notifications_params
    params.require(:notifications).permit(
      :message,
      :options
    )
  end

  def send_notification_to(contacts, message, add_to_payload, kind)
    device_tokens = contacts.map(&:device_token).compact
    notification_options = {
      tokens: device_tokens || [],
      message: message,
      title: "Pânico do Alerta",
      "force-start": 1,
      payload: {
        data: {
          title: "Pânico do Alerta",
          body: message,
          notId: 10,
          'content-available': '1'
        }
      }
    }

    notification_options[:payload][:data].merge!(add_to_payload)

    notification = IonicNotification::Notification.new(notification_options)
    notification.send if device_tokens.present?
    save_user_notification(notification, contacts, kind)
  end

  def save_user_notification(notification, contacts, kind)
    contacts.each do |contact|
      features = notification.as_json.select do |key, value|
        Notification.column_names.include? key
      end
      features[:sender] = current_user
      features[:kind] = kind
      contact.notifications.create(features)
    end
  end
end
