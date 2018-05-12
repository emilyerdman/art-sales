class Buyer < ApplicationRecord
  has_many :listings
  validates :name, presence: true, uniqueness: true
  validates :address, presence: true
  validates :shipping_cost, numericality: { greater_than: 0 }
  attribute :shipping_cost, default: 0.0
end
