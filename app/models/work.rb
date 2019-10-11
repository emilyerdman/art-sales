class Work < ApplicationRecord 
  belongs_to :artist, optional: true
  belongs_to :contact, optional: true
  has_many :apps
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
  NONCORP_VALUE_CEIL = 400.0

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
    if (!heightnum.blank? && !heightden.blank?) 
      height = "%s %s/%s" % [height, heightnum, heightden]
    end
    if (!widthnum.blank? && !widthden.blank?)
      width = "%s %s/%s" % [width, widthnum, widthden]
    end
    if (!depth.blank?)
      if (!depthnum.blank? && !depthden.blank?)
        depth = "%s %s/%s" % [depth, depthnum, depthden]
      end
      return "%s x %s x %s inches" % [height, width, depth]
    else
      return "%s x %s inches" % [height, width]
    end
  end

  def getCategory
    if !self.category.blank? && (self.category.match? /\w+/)
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
      aws_url = '%s%s' % [Rails.application.config.S3_URL, image_url]
      return aws_url
    end
    return '%s%s' % [Rails.application.config.S3_URL, 'notfound.png']
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
      end
      return "Yes"
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
    if !self.current_owner.blank? 
      if self.current_owner > 0
        return Contact.find(self.current_owner)
      end
    elsif !self.contact_id.blank?
      if self.contact_id > -1
        return Contact.find(self.contact_id)
      elsif !self.sold && self.erdman
        return Contact.find(2518) # this is the Erdman Art Group contact
      end
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
        self.getDimensions]
    if !self.getEdition.blank?
      info += "\n\n%s" % self.getEdition
    end
    return info
  end

  def getAvailability
    if self.eag_confirmed
      return 'Yes'
    else
      if !self.current_owner.blank? && self.current_owner > 0
        return "No - Sold To %s" % Contact.find(self.current_owner).getName
      else
        return 'Possibly'
      end
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
        return "Unknown"
      end
    end
    if !self.bin.blank?
      location += "\n\nBin %s" % self.bin
    end
    return location
  end

  def isCorporateCollection
    # coporate collection contact id = 2169
    return !self.location.blank? && self.location == "2169"
  end

  def self.getPostersWorks()
    # poster user can only see posters (but none are EAG confirmed)
    return Work.all.art_type_filter('POSTER').availability_filter('= 0')
  end

  def self.getNonCorpWorks(inc_retail_filter)
    # non corporate can see posters + non corp coll available
    # non corporate can't see any corporate or any non-available fine art
    non_corporate = Work.all.art_type_filter('FINE ART').corp_coll_filter(false).eag_availability_filter(true)
    posters = getPostersWorks()
    works = posters.or(non_corporate)
    # add additional filters
    if (inc_retail_filter)
      retail_below = works.retail_value_filter("< %d" % NONCORP_VALUE_CEIL)
      retail_none = works.retail_value_filter("is NULL")
      return retail_below.or(retail_none)
    else
      return works
    end
  end

  def self.getCorpWorks()
    #corporate can see posters + non corp coll available + corp coll available
    corporate = Work.all.art_type_filter('FINE ART').eag_availability_filter(true)
    return getPostersWorks().or(getNonCorpWorks(false).or(corporate))
  end

  def self.filterByArtType(works, art_type)
    return works.art_type_filter(art_type)
  end

  def self.filterByAvailability(works, availability)
    if ActiveModel::Type::Boolean.new.cast(availability)
      posters_available = works.art_type_filter('POSTER').availability_filter('= 0')
      eag_confirmed = works.eag_availability_filter(true)
      return posters_available.or(eag_confirmed)
    else
      has_current_owner = works.art_type_filter('POSTER').availability_filter('> 0')
      non_eag_confirmed = works.art_type_filter('FINE ART').eag_availability_filter(false)
      return has_current_owner.or(non_eag_confirmed)
    end
  end

  def self.filterByFramed(works, framed)
    return works.framed_filter(ActiveModel::Type::Boolean.new.cast(framed))
  end

  def self.filterByCollection(works, collection)
    if ActiveModel::Type::Boolean.new.cast(collection)
      return works.corp_coll_filter(true)
    else
      return works.corp_coll_filter(false)
    end
  end

  def self.searchWorks(works, keyword)
    stripped_param = keyword.strip.downcase
    works_filtered = works.search_filter(stripped_param)
    contacts_filtered = works.where(artist_id: Artist.artist_filter(stripped_param))
    return works_filtered.or(contacts_filtered)
  end

  def self.filterByCategory(works, categories, operator)
    if operator.eql?("OR")
      all_filtered = Work.none
    else
      all_filtered = works
    end
    categories.each do |category|
      filtered = works.category_filter(category)
      if operator.eql?("OR")
        all_filtered = filtered.or(all_filtered)
      else
        all_filtered = filtered.merge(all_filtered)
      end
     end
    return all_filtered
  end

  def self.filterUnique(works)
    all_unique_works = Work.all.group(:title, :artist_id).calculate(:maximum, :id).values()
    return works.where(id: all_unique_works)
  end

  def self.sortWorks(works, sort_type)
    if sort_type == 0
      works = works.order(inventory_number: :asc).order(title: :asc, artist_id: :asc)
    elsif sort_type == 1
      works = works.order(inventory_number: :desc) 
    elsif sort_type == 2
      works = works.order(title: :desc)
    elsif sort_type == 3
      works = works.order(title: :asc)
    elsif sort_type == 4
      works = works.order(retail_value: :desc).where.not(retail_value: nil)
    elsif sort_type == 5
      works = works.order(retail_value: :asc).where.not(retail_value: nil)
    end
    return works
  end

end
