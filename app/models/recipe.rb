class Recipe < ApplicationRecord
  belongs_to :user
  has_many :recipe_foods, dependent: :destroy
  has_many :foods, through: :recipe_foods

  validates :name, :preparation_time, :cooking_time, :description, presence: true
  validates :preparation_time, :cooking_time, numericality: { greater_than_or_equal_to: 0 }

  def total_price
    recipe_foods.includes(:food).map { |recipe_food| recipe_food.food.price * recipe_food.quantity }.sum
  end
end
