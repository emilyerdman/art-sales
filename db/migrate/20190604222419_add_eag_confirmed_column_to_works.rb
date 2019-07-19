class AddEagConfirmedColumnToWorks < ActiveRecord::Migration[5.1]
  def change
    add_column(:works, :eag_confirmed, :boolean, default: false)
  end
end
