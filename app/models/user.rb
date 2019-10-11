class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
  enum category: [:posters, :non_corporate, :corporate, :admin]

  def getAddressString
    user = self
    "%s\n%s, %s %s\n%s" % [user.address['street_address'], user.address['city'], user.address['state'], user.address['zip'], user.address['country']]
  end

  def approve_user(boolean_val)
    self.update_attribute(:approved, boolean_val)
  end

  def change_user_category(new_category)
    self.update_attribute(:category, User.categories[new_category])
  end

  def generate_password_token!
   self.reset_password_token = generate_token
   self.reset_password_sent_at = Time.now.utc
   save!
  end

  def password_token_valid?
   (self.reset_password_sent_at + 4.hours) > Time.now.utc
  end

  def reset_password!(password)
   self.reset_password_token = nil
   self.password = password
   save!
  end

  private

  def generate_token
   SecureRandom.hex(10)
  end
end
