class App < ApplicationRecord
  belongs_to :user
  belongs_to :work

  def approve(boolean_val)
    self.update_attribute(:approved, boolean_val)
  end

  def getOrganization()
    if !self.organization.empty?
      return self.organization
    elsif !self.user.company.empty?
      return self.user.company
    else
      return 'None'
    end
  end

end
