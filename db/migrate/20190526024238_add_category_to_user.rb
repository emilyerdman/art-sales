class AddCategoryToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :user_category, :string
  end
end
