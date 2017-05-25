class User < ApplicationRecord
  has_many :contacts, dependent: :destroy
  has_many :emergency_contacts, :through => :contacts, dependent: :destroy

  has_secure_password

  after_create :generate_authentication_token!
  after_validation { self.errors.messages.delete(:password_digest) }

  scope :by_email_or_username, ->(param) { where("username = :param OR email = :param", param: param) }

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
    emergency_contacts.where(contacts: { status: :accept })
  end

  def refused_dependent_requests
    emergency_contacts.where(contacts: { status: :refuse })
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

  def refuse_friendship_of contact
    emergency_contact_request_of(contact).refuse!
  end

  def drop_contact contact
    emergency_contacts.destroy contact
  end

  # def emergency_contact_request_sent? contact
  #   emergency_contacts.include?(contact) && friendship_between(user).pending?
  # end

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
end
