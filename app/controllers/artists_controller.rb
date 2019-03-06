  class ArtistsController < ApplicationController
    WORKS_NUM = 10
  def show
    @artist = Artist.find(params[:id])
    @works = @artist.works.limit(WORKS_NUM)
  end

end
