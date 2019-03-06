class CreateWorks < ActiveRecord::Migration[5.1]
  def change
    create_table :works do |t|
      t.string :inventory_number
      t.string :title
      t.string :art_type
      t.string :full_year
      t.string :media
      t.integer :hinw
      t.integer :hinn
      t.integer :hind
      t.integer :winw
      t.integer :winn
      t.integer :wind
      t.integer :dinw
      t.integer :dinn
      t.integer :dind
      t.string :numerator
      t.string :denominator
      t.string :set
      t.decimal :base_net_amount
      t.decimal :base_purchase_price
      t.decimal :retail_value
      t.string :category
      t.string :image
      t.boolean :framed
      t.string :frame_condition
      t.integer :current_owner
      t.boolean :sold
      t.boolean :erdman
    end
  end
end
