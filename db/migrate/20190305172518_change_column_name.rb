class ChangeColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :works, :corporate_collecton, :corporate_collection
  end
end
