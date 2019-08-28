class AddInventoryIndexToWorks < ActiveRecord::Migration[5.1]
  def change
    add_index :works, :inventory_number
  end
end
