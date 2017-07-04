module NotificationHelper
  extend ActiveSupport::Concern

  def send_notification_to(contacts, add_to_payload)
    @contacts = contacts
    @notification_code = DateTime.now.to_s :for_code
    options = base_notification_options.merge(add_to_payload)
    notify!(options)
  end

  private
  def base_notification_options
    device_tokens = ensure_contacts_type.map(&:device_token).compact
    notification_options = {
      tokens: device_tokens || [],
      title: "Alerta do Pânico",
      payload: {
        data: {
          title: "Alerta do Pânico",
          notId: @notification_code
        }
      }
    }
  end

  def save_user_notification(notification, kind)
    features = notification.as_json.select do |key, value|
      Notification.column_names.include? key
    end
    features[:sender] = current_user
    features[:kind] = kind
    features[:code] = @notification_code
    features['android_payload'] = features['android_payload'].to_json
    features['ios_payload'] = features['ios_payload'].to_json

    notification = Notification.create(features)
    NotificationUser.create attributes_list(notification)
  end

  def notify!(options)
    notification = IonicNotification::Notification.new(options)
    notification.send if options[:tokens].present?
    save_user_notification(notification, options[:payload][:data][:kind])
  end

  def attributes_list(notification)
    ensure_contacts_type.map { |c| {destiny: c, notification_id: notification.id} }
  end

  def ensure_contacts_type
    return [@contacts] unless @contacts.respond_to? :map
    @contacts
  end
end
