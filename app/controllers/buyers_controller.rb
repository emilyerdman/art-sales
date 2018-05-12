class BuyersController < ApplicationController

  def index
    @buyers = Buyer.all
  end

  def show
    @buyer = Buyer.find(params[:id])
  end

  def new
    @buyer = Buyer.new
  end

  def create
    @buyer = Buyer.new(buyer_params)
    if @buyer.save then
      redirect_to @buyer
    else
      render 'new'
    end
  end

  # new_listing is a new buyer creation while a user is in the middle of creating
  # a new listing. It saves the listing in process so it can be passed in the next
  # request.
  def new_listing
    @prev_listing = Listing.new(params.require(:listing).permit(:site, :start_datetime, :sold_datetime, :link, :start_price, :sale_price))
    @buyer = Buyer.new
  end

  # create_listing grabs the prev_listing that's been passed from the new_listing buyer
  # creation page and redirects back to the edit listing page with the data still
  # available
  def create_listing
    @prev_listing = Listing.new(params.require(:listing).permit(:site, :start_datetime, :sold_datetime, :link, :start_price, :sale_price))
    @buyer = Buyer.new(buyer_params)
    if @buyer.save then
      redirect_to edit_piece_listing_url(Listing.find(@prev_listing.id).piece_id, @prev_listing)
    else
      render 'new_listing'
    end
  end

  def edit
    @buyer = Buyer.find(params[:id])
  end

  def update
    @buyer = Buyer.find(params[:id])
    if @buyer.update(buyer_params)
      redirect_to @buyer
    else
      render 'edit'
    end
  end

  private
  def buyer_params
    params.require(:buyer).permit(:name, :address, :shipping_cost)
  end
end
