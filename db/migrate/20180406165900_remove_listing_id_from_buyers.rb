class RemoveListingIdFromBuyers < ActiveRecord::Migration[5.1]
  def change
    remove_column :buyers, :listing_id, :integer
  end
end
