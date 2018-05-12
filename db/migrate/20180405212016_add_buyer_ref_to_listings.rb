class AddBuyerRefToListings < ActiveRecord::Migration[5.1]
  def change
    add_reference :listings, :buyer, foreign_key: true
  end
end
