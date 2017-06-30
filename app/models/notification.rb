class Notification < ApplicationRecord
  has_many :notification_users, class_name: 'NotificationUser', dependent: :destroy
  has_many :destinies, class_name: 'User', through: :notification_users

  belongs_to :sender, class_name: 'User'

  scope :help_requests_by, ->(user) { where(sender: user, kind: :help_request).order(created_at: :desc) }

  def sender_display_name
    contact = Contact.where(user: destinies.first, emergency_contact: sender).first
    return contact.display_name if contact.present? && contact.display_name.present?
    sender.name
  end

  def as_json(options={})
    super(
      include: {
        sender: {
          only: [:name, :username],
          methods: [:complete_phone_number]
        }
      },
      methods: [:sender_display_name]
    )
  end
end
