  class ArtistsController < ApplicationController
  def show
    @artist = Artist.find(params[:id])
    @works = @artist.works
  end

end
