class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
  enum category: [:posters, :non_corporate, :corporate, :admin]

  def getAddressString
    user = self
    "%s\n%s,%s %s\n%s" % [user.address['street_address'], user.address['city'], user.address['state'], user.address['zip'], user.address['country']]
  end

  def approve_user(boolean_val)
    self.update_attribute(:approved, boolean_val)
  end

  def change_user_category(new_category)
    puts 'updating to %s' % new_category
    self.update_attribute(:category, User.categories[new_category])
  end
end
