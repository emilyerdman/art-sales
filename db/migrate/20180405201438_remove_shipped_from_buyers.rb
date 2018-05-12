class RemoveShippedFromBuyers < ActiveRecord::Migration[5.1]
  def change
    remove_column :buyers, :shipped, :boolean
  end
end
