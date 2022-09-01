class Food < ApplicationRecord
  belongs_to :user
  has_many :recipe_foods
  has_many :recipes, through: :recipe_foods, dependent: :destroy

  validates :name, :measurement_unit, :quantity, presence: true
  validates :quantity, :price, numericality: { greater_than_or_equal_to: 0 }
end
