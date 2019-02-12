class CreateMedias < ActiveRecord::Migration[5.1]
  def change
    create_table :medias do |t|
      t.string :media
    end
  end
end
