json.extract! help_request, :id, :android_payload, :ios_payload, :code
json.created_at help_request.created_at.to_s
json.destinations do
  json.array! help_request.notification_users, partial: 'users/destination', as: :destination
end
