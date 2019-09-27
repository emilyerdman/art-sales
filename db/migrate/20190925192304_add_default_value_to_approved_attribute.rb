class AddDefaultValueToApprovedAttribute < ActiveRecord::Migration[5.1]
  def change
    change_column :apps, :approved, :boolean, default: false
  end
end
