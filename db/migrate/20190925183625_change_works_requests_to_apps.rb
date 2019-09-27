class ChangeWorksRequestsToApps < ActiveRecord::Migration[5.1]
  def change
    rename_table :works_requests, :apps
  end
end
