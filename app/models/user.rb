class User < ApplicationRecord
  # Include IonicNotification behaviour
  include IonicNotification::Concerns::IonicNotificable

  has_many :notifications
  has_many :contacts
  has_many :emergency_contacts, :through => :contacts, dependent: :destroy

  has_secure_password

  after_create :generate_authentication_token!
  before_validation :remove_extremity_whitespace, on: :create
  after_validation { self.errors.messages.delete(:password_digest) }

  scope :by_email_or_username, ->(param) { where("username = :param OR email = :param", param: param) }

  validates :email, :username, :phone_number, presence: true, uniqueness: true
  validates :ddd, presence: true, length: { is: 2 }, numericality: true
  validates :phone_number, length: { in: 8..9}, numericality: true
  validates :username, format: { without: /\s/ }

  def logout
  end

  def as_json(options = {})
    options[:except] ||= [:password_digest, :authentication_token]
    super(options)
  end

  def to_json(options = {})
    options[:except] ||= [:password_digest, :authentication_token]
    super(options)
  end

  def self.find_by_email_or_username(param)
    by_email_or_username(param).first
  end

  # EMERGENCY CONTACT SEARCHES
  def accepted_dependent_requests
    emergency_contacts.select('users.*, contacts.display_name').where(contacts: { status: :accept })
  end

  def refused_dependent_requests
    emergency_contacts.select('users.*, contacts.display_name').where(contacts: { status: :refuse })
  end

  def pending_dependent_requests
    Contact.where(emergency_contact: self, status: :pending).map { |f| f.user }
  end

  # EMERGENCY CONTACT ACTIONS

  def add_for_emergency_contact(contact)
    emergency_contacts << contact
  end

  def accept_emergency_contact_of contact
    emergency_contact_request_of(contact).accept!
  end

  def refuse_emergency_contact_of contact
    emergency_contact_request_of(contact).refuse!
  end

  def drop_contact contact
    emergency_contacts.destroy contact
  end

  # def emergency_contact_request_sent? contact
  #   emergency_contacts.include?(contact) && friendship_between(user).pending?
  # end

  def complete_phone_number
    "+55#{ddd}#{phone_number}"
  end

  def sender_display_name(user)
    sender ||= user
  end

  def my_help_requests
    Notification.help_requests_by(self).includes(:notification_users)
  end

  def received_notifications
    Notification.joins(:notification_users).where(notification_users: {destiny: self})
  end

  private
  # Generate a session token
  def generate_authentication_token!
    self.authentication_token = Digest::SHA1.hexdigest("#{Time.now}-#{self.id}-#{self.updated_at}")
    self.save
  end

  def emergency_contact_request_of contact
    Contact.where(user: contact, emergency_contact: self).first
  end

  # def friendship_between friend
  #   friendships.where(friend: friend).first
  # end

  def remove_extremity_whitespace
    self.username = self.username.strip
  end
end
