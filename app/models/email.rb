class Email < ActiveRecord::Base
  belongs_to :domain

  devise :database_authenticatable, :recoverable, :lockable

  scope :active, where(:active => true)
  scope :inactive, where(:active => false)
  scope :expired, active.where("expires_on <= ?", Date.today)
  scope :to_be_expired, inactive.where("expires_on <= ?", Date.today)

  # access and validation

  attr_accessible :email, :password, :password_confirmation, :comment, :expires_on, :email_path, :forwards, :alt_email, :reminder_sent, :active, :domain_id, :last_activity_on, :admin, :can_receive, :can_send
  attr_reader :prefix

  validates :email, :presence => true ,:format => { :with => /^[\w-]+(\.[\w-]+)*@([a-z0-9-]+(\.[a-z0-9-]+)*?\.[a-z]{2,6}|(\d{1,3}\.){3}\d{1,3})(:\d{4})?$/i,
    :message => "%{value} has invalid format" }
  validates :password, :presence => true, :if => :password_validation_required?
  validates :email_path, :presence => true
  validates :domain_id, :presence => true
  validates_associated :domain

  validates :alt_email, :presence => {:message => '- If email can expire, the alternative email must be set'}, :if => "not expires_on.blank?"
  validates :alt_email, :format => { :with => /^[\w-]+(\.[\w-]+)*@([a-z0-9-]+(\.[a-z0-9-]+)*?\.[a-z]{2,6}|(\d{1,3}\.){3}\d{1,3})(:\d{4})?$/i,
    :message => "- Alternative email: %{value} has invalid format" },:allow_blank => true, :allow_nil => true

  before_validation :convert_email

  #static methods
  def forwards
    forward_email.try(:split, " ") || []
  end

  def forwards=(array_or_string)
    array_or_string = array_or_string.split(/\s+/) if array_or_string.is_a? String

    self.forward_email = array_or_string.map(&:downcase).uniq.join(" ")
  end

  def self.get_emails_expires_soon
    Email.where("expires_on <= ? and reminder_sent = ? and active = ? and admin = ?",(Date.today + 14.days),false,true,false)
  end
  
  def password_salt=(password_salt)
  end

  def password_salt
  end

  def password_digest(password)
    password.crypt("2a")
  end

  def prefix
    email.split("@").first if email
  end

  def self.search(search)
    if search
      where('email LIKE ?', "%#{search}%")
    else
      scoped
    end
  end

  def send_reset_password_instructions
    generate_reset_password_token! if should_generate_reset_token?
    EmailMailer.reset_password_instructions(self).deliver
  end

  def send_unlock_instructions
    EmailMailer.expires_email(self).deliver
  end

  end

  alias :devise_valid_password? :valid_password?
  def valid_password?(password)
    if self.admin
      begin
        devise_valid_password?(password)
      rescue BCrypt::Errors::InvalidHash
        password.crypt(encrypted_password[0..2]) == encrypted_password
      end
    end
  end
  
  private
  
  def convert_email
    domain_value = Domain.find(self.domain_id).name
    self.email = get_email_prefix(self.email)
    self.email = self.email + '@' + domain_value
  end
  
  def password_validation_required?
    self.encrypted_password.blank? || !self.password.blank?
  end
end
