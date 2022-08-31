class Food < ApplicationRecord
  belongs_to :user

  validates :name, :measurement_unit, :quantity, presence: true
  validates :quantity, :price, numericality: { greater_than_or_equal_to: 0 }
end
