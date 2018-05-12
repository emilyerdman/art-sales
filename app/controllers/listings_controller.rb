class ListingsController < ApplicationController
 
  def index
    @piece = Piece.find(params[:piece_id])
  end

  def show
    @listing = Listing.find(params[:id])
    @piece = Piece.find(params[:piece_id])
  end

  def all
    @pieces = Piece.all
  end

  def new
    @piece = Piece.find(params[:piece_id])
    @listing = @piece.listings.new
    @buyers = Buyer.all
  end

  def create
    piece = Piece.find(params[:piece_id])
    @listing = piece.listings.new(listing_params)
    if @listing.save then
      redirect_to @listing
    else
      render 'new'
    end
  end

  def edit
    @listing = Listing.find(params[:id])
  end

  def update
    @listing = Listing.find(params[:id])
    if @listing.update(listing_params)
      redirect_to @listing
    else
      render 'edit'
    end
  end

  private 
  def listing_params
    params.require(:listing).permit(:site, :start_datetime, :sold_datetime, :link, :start_price, :sale_price)
  end

end
