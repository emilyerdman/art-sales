class Artist < ApplicationRecord
  has_many :works
  scope :artist_filter, -> (param) {where('LOWER(first_name) LIKE :search OR LOWER(last_name) LIKE :search', search: "%#{param}%")}

  def getName
    return '%s %s' % [self.first_name, self.last_name]
  end

end
