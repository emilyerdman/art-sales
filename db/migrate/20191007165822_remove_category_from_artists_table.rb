class RemoveCategoryFromArtistsTable < ActiveRecord::Migration[5.1]
  def change
    remove_column :artists, :category
  end
end
