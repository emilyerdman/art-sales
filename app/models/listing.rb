class Listing < ApplicationRecord
	belongs_to :piece
  belongs_to :buyer, optional: true
  validates :site, presence: true
  validates :start_datetime, presence: true
  validates :link, presence: true
  validates :start_price, presence: true, numericality: { greater_than: 0 }
  validates :sale_price, numericality: { greater_than: 0 }, allow_blank: true
  attribute :shipped, default: false
end
