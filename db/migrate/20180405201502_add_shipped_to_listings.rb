class AddShippedToListings < ActiveRecord::Migration[5.1]
  def change
    add_column :listings, :shipped, :boolean
  end
end
