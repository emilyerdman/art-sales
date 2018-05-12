class CreatePieces < ActiveRecord::Migration[5.1]
  def change
    create_table :pieces do |t|
      t.string :title
      t.string :artist
      t.date :date
      t.float :purchase_price
      t.string :picture
      t.string :print_number

      t.timestamps
    end
  end
end
