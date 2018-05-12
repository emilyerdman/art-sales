class RemoveBuyerRefFromListings < ActiveRecord::Migration[5.1]
  def change
    remove_reference :listings, :buyers, foreign_key: true
  end
end
