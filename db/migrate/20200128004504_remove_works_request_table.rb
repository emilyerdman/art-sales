class RemoveWorksRequestTable < ActiveRecord::Migration[5.1]
  def change
    drop_table :works_requests
  end
end
