class User < ApplicationRecord
  after_create :generate_authentication_token!
  after_validation { self.errors.messages.delete(:password_digest) }

  scope :by_email_or_username, ->(param) { where("username = :param OR email = :param", param: param) }

  has_secure_password

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

  private
  # Generate a session token
  def generate_authentication_token!
    self.authentication_token = Digest::SHA1.hexdigest("#{Time.now}-#{self.id}-#{self.updated_at}")
    self.save
  end
end
