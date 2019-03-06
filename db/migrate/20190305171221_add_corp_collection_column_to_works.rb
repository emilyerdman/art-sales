class AddCorpCollectionColumnToWorks < ActiveRecord::Migration[5.1]
  def change
    add_column :works, :corporate_collecton, :boolean
  end
end
