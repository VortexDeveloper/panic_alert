class Contact < ApplicationRecord
  belongs_to :user
  belongs_to :emergency_contact, class_name: 'User'

  before_create :initialize_status

  validates :emergency_contact, uniqueness: { scope: :user }

  enum status: [
    :pending,
    :accept,
    :refuse
  ]

  private

  def initialize_status
    self.status ||= :pending
  end
end
