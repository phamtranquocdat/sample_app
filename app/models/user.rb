class User < ApplicationRecord
  attr_accessor :remember_token
  before_save { email.downcase! }  
  validates :name, presence: true, length: { maximum: Settings.user.username_length }
  VALID_EMAIL_REGEX = Settings.user.email_regex
  validates :email, presence: true, length: { maximum: Settings.user.email_length },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: Settings.user.password_min }, allow_nil: true          

  class << self
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
             BCrypt::Engine.cost   
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_column(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_column(:remember_digest, nil)
  end

end
