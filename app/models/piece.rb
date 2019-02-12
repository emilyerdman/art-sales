class Piece < ApplicationRecord
  has_many :listings
  validates :title, presence: true
  validates :artist, presence: true
  validates :date, presence: true
  validates :purchase_price, numericality: { greater_than: 0 }, allow_blank: true
  validates :print_number, format: { with: /\d{1,}\/\d{1,}/, message: "Must be in x/x format." }, allow_blank: true
end

