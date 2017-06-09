class Notification < ApplicationRecord
  has_many :notification_users, class_name: 'NotificationUser', dependent: :destroy
  has_many :users, through: :notification_users, dependent: :destroy

  belongs_to :sender, class_name: 'User', dependent: :destroy

  def sender_display_name
    Contact.where(user: users.first, emergency_contact: sender).first.display_name
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
