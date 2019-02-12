class CreateContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :contacts do |t|
      t.string :contact_description
      t.string :title
      t.string :first_name
      t.string :last_name
      t.string :position
      t.string :institution
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state_prov
      t.string :postal_code
      t.string :country
      t.string :notes
    end
  end
end
