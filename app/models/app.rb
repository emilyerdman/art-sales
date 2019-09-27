class App < ApplicationRecord
  belongs_to :user
  belongs_to :work

  def approve(boolean_val)
    self.update_attribute(:approved, boolean_val)
  end

end
