class CreateWorksRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :works_requests do |t|
      t.string :organization
      t.boolean :approved
      t.text :comment
      t.timestamps
    end
    add_reference :works_requests, :user, foreign_key: true
    add_reference :works_requests, :work, foreign_key: true
  end
end
