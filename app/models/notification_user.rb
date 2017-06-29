class NotificationUser < ApplicationRecord
  belongs_to :notification, dependent: :destroy
  belongs_to :destiny, class_name: 'User'

  before_create :initialize_status

  enum status: [:pending, :sent, :received]

  scope :find_by_user_and_code, ->(user, code) { joins(:notification).where(user: user, notifications: {code: code}).first}

  delegate :name, :username, :phone_number, to: :destiny

  def initialize_status
    if destiny.device_token
      self.status = :sent
    else
      self.status = :pending
    end
  end
end
