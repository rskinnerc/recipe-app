class Food < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, length: { maximum: 25 }
  validates :measurement_unit, presence: true, length: { maximum: 5 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
