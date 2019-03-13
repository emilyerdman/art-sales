class Artist < ApplicationRecord
  has_many :works
  scope :artist_filter, -> (param) {where('UPPER(first_name) LIKE :search OR UPPER(last_name) LIKE :search', search: "%#{param.upcase}%")}

  def getName
    return '%s %s' % [self.first_name, self.last_name]
  end

end
