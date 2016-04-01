class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token
  before_save :downcase_email
  before_create :create_activation_digest
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\.-]+@[a-z\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 250 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 },
                                                                                  allow_blank: true

#returns hash digest of a given string
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST  :
                                                                                                   BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

# Returns a random token
  def User.new_token
    SecureRandom.urlsafe_base64
  end

# Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest,  User.digest(remember_token))
  end

  #returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  #activates user via email, setting activated to true and activated_at to database
  def activate()
    self.update_attribute(:activated, true)
    self.update_attribute(:activated_at, Time.zone.now)
  end

  #sends activation email to user
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private

  #creates and assigns the activation token and digest
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest =  User.digest(activation_token)
  end

  #downcases the user email
  def downcase_email
    self.email = email.downcase
  end



end
