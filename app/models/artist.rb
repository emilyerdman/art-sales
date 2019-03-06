class Artist < ApplicationRecord
  has_many :works

  def getName
    return '%s %s' % [self.first_name, self.last_name]
  end

end
