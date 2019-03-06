class CreateContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :contacts do |t|
      t.string :description
      t.string :first_name
      t.string :last_name
      t.string :institution
    end
  end
end
