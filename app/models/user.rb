class User < ApplicationRecord
  before_save { email.downcase! }  
  validates :name, presence: true, length: { maximum: Settings.user.username_length }
  VALID_EMAIL_REGEX = Settings.user.email_regex
  validates :email, presence: true, length: { maximum: Settings.user.email_length },
            format: { with: VALID_EMAIL_REGEX }
            uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: Settings.user.password_min }          
end
