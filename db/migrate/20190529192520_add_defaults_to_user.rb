class AddDefaultsToUser < ActiveRecord::Migration[5.1]
  def change
    change_column_default(:users, :approved, false)
    change_column_default(:users, :category, 0)
  end
end
