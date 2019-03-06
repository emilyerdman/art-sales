class Contact < ApplicationRecord
  has_many :works
  has_many :artists

  def getName
    if !self.first_name.blank?
      return "%s %s" % [self.first_name, self.last_name]
    else
      return self.institution
    end
  end

  def getAddress
    return "%s %s\n\n%s, %s %s" % [self.address1, self.address2, self.city, self.state_prov, self.postal_code]
  end

  def getInfo
    info = ""
    if !self.institution.blank?
      if !self.address1.blank?
        info = "%s\n\n%s" % [self.institution, self.getAddress]
      else
        info = self.institution
      end
    end
    return info
  end
end
