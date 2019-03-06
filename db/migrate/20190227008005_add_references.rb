class AddReferences < ActiveRecord::Migration[5.1]
  def change
    add_reference :works, :contact, foreign_key: true
    add_reference :works, :artist, foreign_key: true
  end
end
