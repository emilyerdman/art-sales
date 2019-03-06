class AddLocationToWorks < ActiveRecord::Migration[5.1]
  def change
    add_column :works, :location, :string
    add_column :works, :bin, :string
    add_column :contacts, :address1, :string
    add_column :contacts, :address2, :string
    add_column :contacts, :city, :string
    add_column :contacts, :state_prov, :string
    add_column :contacts, :postal_code, :string
  end
end
