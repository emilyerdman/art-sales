class CreateBuyers < ActiveRecord::Migration[5.1]
  def change
    create_table :buyers do |t|
      t.references :listing, foreign_key: true
      t.string :name
      t.string :address
      t.decimal :shipping_cost
      t.boolean :shipped

      t.timestamps
    end
  end
end
