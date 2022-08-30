class Recipe < ApplicationRecord
  belongs_to :user

  validates :name, :preparation_time, :cooking_time, :public, :description, presence: true
  validates :preparation_time, :cooking_time, numericality: { greater_than_or_equal_to: 0 }
end
