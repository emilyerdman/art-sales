class CreateListings < ActiveRecord::Migration[5.1]
  def change
    create_table :listings do |t|
      t.string :site
      t.datetime :start_datetime
      t.datetime :sold_datetime
      t.string :link
      t.decimal :start_price
      t.decimal :sale_price

      t.timestamps
    end
  end
end
