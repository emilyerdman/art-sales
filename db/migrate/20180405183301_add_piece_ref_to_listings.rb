class AddPieceRefToListings < ActiveRecord::Migration[5.1]
  def change
    add_reference :listings, :piece, foreign_key: true
  end
end
