class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true

  private
  def user_params
    params.require(:user, :email, :first_name, :last_name).permit(:phone, :company, address: [:street_address, :city, :state, :zip, :country])
  end
end
