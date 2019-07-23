class Work < ApplicationRecord 
  belongs_to :artist, optional: true
  belongs_to :contact, optional: true
  scope :art_type_filter, -> (param) { where(art_type: param)}
  scope :eag_availability_filter, -> (param) { where(eag_confirmed: param)}
  scope :availability_filter, -> (param) { where("current_owner #{param}") }
  scope :framed_filter, -> (param) {where(framed: param)}
  scope :corp_coll_filter, -> (param) { where(corporate_collection: param)}
  scope :category_filter, -> (param) { where("category LIKE ?", "%#{param}%")}
  scope :search_filter, -> (param) {where('LOWER(category) LIKE :search OR 
                                           LOWER(title) LIKE :search OR 
                                           LOWER(media) LIKE :search OR 
                                           LOWER(inventory_number) LIKE :search', search: "%#{param}%")}
  scope :retail_value_filter, -> (param) { where("retail_value #{param}")}
  S3_URL = "https://s3.us-east-2.amazonaws.com/works-images/"

  def getArtist
    artist = self.artist
    if artist.nil?
      return 'UNKNOWN'
    else
      return artist.getName
    end
  end
   
  def getDimensions
    height = self.hinw
    heightnum = self.hinn
    heightden = self.hind
    width = self.winw
    widthnum = self.winn
    widthden = self.wind
    depth = self.dinw
    depthnum = self.dinn
    depthden = self.dind
    if height.blank? || width.blank?
      return ''
    end
    if (!heightnum.blank? || !heightden.blank?) 
      height = "%s %s/%s" % [height, heightnum, heightden]
    end
    if (!widthnum.blank? || !widthden.blank?)
      width = "%s %s/%s" % [width, widthnum, widthden]
    end
    if (!depth.blank?)
      if (!depthnum.blank? || !depthden.blank?)
        depth = "%s %s/%s" % [depth, depthnum, depthden]
      end
      return "%s x %s x %s inches" % [height, width, depth]
    else
      return "%s x %s inches" % [height, width]
    end
  end

  def getCategory
    if self.category.match? /\w+/
      return self.category
    else
      return ''
    end
  end
  
  def getEdition
    if (!self.numerator.blank? && !self.denominator.blank?)
      return 'Edition %s of %s %s' % [self.numerator, self.denominator, self.set]
    else 
      if (!self.set.blank?) 
        return self.set
      else 
        return ''
      end
    end
  end
  
  def getImageUrl
    if !self.image.nil? && !self.image.empty?
      image_only = self.image[/[^\?]+/]
      image_url = image_only[3..-1].gsub('\\', '/').gsub(']', '').sub('Image', 'image').sub('.JPG', '.jpg')
      aws_url = '%s%s' % [S3_URL, image_url]
      return aws_url
    end
    return '%s%s' % [S3_URL, 'notfound.png']
  end
  
  def getFrame
    if self.framed
      if !self.frame_condition.blank?
        split = self.frame_condition.split(' ')
        if (split.size > 1)
          return "Yes - %s" % split[1]
        elsif !split[0].match? /\A\d+\z/
          return "Yes - %s" % self.frame_condition
        end
      else
        return "Yes"
      end
    else
      return "Not Framed"
    end
  end

  def getRetailValue
    if self.retail_value.blank? || self.retail_value == 0.0
      return 'Unknown'
    else
      return '$%.2f' % self.retail_value
    end
  end

  def getOwner
    if self.current_owner > 0
      return Contact.find(self.current_owner)
    elsif self.contact_id > -1
      return Contact.find(self.contact_id)
    elsif !self.sold && self.erdman
      return Contact.find(2518) # this is the Erdman Art Group contact
    else
      return nil
    end
  end

  def getDisplayInfo
    info = "%s%s\n\n%s\n\n%s" % 
      [self.title, 
        if self.full_year.blank? 
          '' 
        else ', '+self.full_year 
        end, 
        self.media, 
        self.getDimensions, 
        self.getEdition]
    if !self.getEdition.blank?
      info += "\n\n%s" % self.getEdition
    end
    return info
  end

  def getAvailability
    if self.eag_confirmed
      return 'Yes'
    else
      avail = 'No '
      if self.current_owner > 0
        avail += "- Sold To %s" % Contact.find(self.current_owner).getName
      end
      return avail
    end
  end

  def getLocation
    location = 'Last Known - '
    if self.eag_confirmed
      location = 'Erdman Art Group'
    else
      # try to find the contact id
      if !self.location.blank?
        contact = Contact.find(self.location)
        if !contact.blank?
          location += contact.getInfo
        end
      else
        location += self.location
      end
    end
    if !self.bin.blank?
      location += "\n\nBin %s" % self.bin
    end
    return location
  end

  def isCorporateCollection
    # coporate collection contact id = 2169
    contact = Contact.find(self.location)
    if contact.id == "2169"
      return true
    end
    return false
  end

end
