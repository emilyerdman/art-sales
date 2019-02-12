class CreateArtists < ActiveRecord::Migration[5.1]
  def change
    create_table :artists do |t|
      t.string :first_name
      t.string :last_name
      t.string :dates
      t.string :contact_number
      t.string :category
    end
  end
end
