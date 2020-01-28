class Contact < ApplicationRecord
  has_many :works
  has_many :artists

  def getName
    if !self.first_name.blank? && !self.last_name.blank?
      return "%s %s" % [self.first_name, self.last_name]
    elsif !self.first_name.blank?
      return self.first_name
    elsif !self.last_name.blank?
      return self.last_name
    elsif !self.institution.blank?
      return self.institution
    else
      return ''
    end
  end

  def getAddress
    address_string = ''
    if !self.address1.blank?
      address_string += self.address1
      if !self.address2.blank?
        address_string += ' %s' % self.address2
      end
      if !self.city.blank? || !self.state_prov.blank? || !self.postal_code.blank?
        address_string += "\n\n"
      end
    end
    if !self.city.blank?
      address_string += "%s" % self.city
      if !self.state_prov.blank?
        address_string += ', %s' % self.state_prov
      end
      if !self.postal_code.blank?
        address_string += ' '
      end
    elsif !self.state_prov.blank?
      address_string += "%s" % self.state_prov
      if !self.postal_code.blank?
        address_string += ' '
      end
    end
    if !self.postal_code.blank?
      address_string += '%s' % self.postal_code
    end
    return address_string
  end

  def getInfo
    info = ""
    if !self.institution.blank?
      info = self.institution
    else 
      if !self.first_name.blank? && !self.last_name.blank?
        info = "%s %s" % [first_name, last_name]
      end
    end
    if !self.city.blank? || !self.state_prov.blank?
      city = ''
      if !self.city.blank?
        city = self.city
      end
      if !self.state_prov.blank?
        if self.city.blank?
          city = self.state_prov
        else
          city += ', %s' % self.state_prov
        end
      end
      if !self.institution.blank? || (!self.first_name.blank? && !self.last_name.blank?)
        info += "\n\n"
      end
      info += city
    end
    return info
  end
end
