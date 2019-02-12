class ChangeMediaColumnType < ActiveRecord::Migration[5.1]
  def change
    change_column :works, :media, :string
  end
end
