class AddCategoryColumnToUsers < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :category, :integer
  end

  def down
    remove_column :users, :category
  end
end
