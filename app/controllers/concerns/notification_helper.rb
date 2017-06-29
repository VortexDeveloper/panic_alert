module NotificationHelper
  extend ActiveSupport::Concern

  def save_user_notification(notification, contacts, kind, code)
    features = notification.as_json.select do |key, value|
      Notification.column_names.include? key
    end
    features[:sender] = current_user
    features[:kind] = kind
    features[:code] = code
    features['android_payload'] = features['android_payload'].to_json
    features['ios_payload'] = features['ios_payload'].to_json

    notification = Notification.create(features)
    NotificationUser.create attributes_list(contacts, notification)
  end

  private
  def attributes_list(contacts, notification)
    contacts = [contacts] unless contacts.respond_to? :map
    contacts.map { |c| {destiny: c, notification_id: notification.id} }
  end
end
