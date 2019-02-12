class WorksController < ApplicationController

  def all
    @works = Works.first(25)
  end

  private
  def getArtist
    artist = Artists.find(self.artist)
    if artist.nil?
      return 'UNKNOWN'
    else
      return '%s %s' % [artist.first_name, artist.last_name]
    end
  end

  private 
  def getDimensions
    height = self.hinw
    heightnum = self.hinn
    heightden = self.hind
    width = self.winw
    widthnum = self.winn
    widthdun = self.wind
    depth = self.dinw
    depth = self.dinn
    depth = self.dind
    if (!heightnum.nil? || !heightden.nil?) 
      height = "%s %s/%s" % [height, heightnum, heightden]
    end
    if (!widthnum.nil? || !widthden.nil?)
      width = "%s %s/%s" % [width, widthnum, widthden]
    end
    if (!depth.nil?)
      if (!depthnum.nil? || !depthden.nil?)
        depth = "%s %s/%s" % [depth, depthnum, depthden]
      end
      return "%s'' X %s''" % [height, width]
    else
      return "%s'' X %s'' X %s''" % [height, width, depth]
    end
  end

  private
  def getEdition
    return '%s/%s %s' % [self.numerator, self.denominator, self.set]
  end

  private
  def getImage
    return self.image.subString(2)
  end

  private
  def getFrame
    if self.framed
      return self.frame_condition
    else
      return "NO FRAME"
    end
  end

end