class RemoveUserCategoryColumn < ActiveRecord::Migration[5.1]
  def up
    remove_column :users, :category
  end

  def down
    add_column :users, :category
  end
end
