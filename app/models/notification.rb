class Notification < ApplicationRecord
  has_many :notification_users, class_name: 'NotificationUser', dependent: :destroy
  has_many :users, through: :notification_users, dependent: :destroy
end
