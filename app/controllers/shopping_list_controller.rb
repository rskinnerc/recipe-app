class ShoppingListController < ApplicationController
  before_action :authenticate_user!
  def index
    @required = []
    current_user.foods.each do |food|
      required = food.recipe_foods.sum(:quantity) - food.quantity
      unless required <= 0
        @required << { name: food.name, required:, measurement_unit: food.measurement_unit,
                       price: food.price * required }
      end
    end
    @total_value = @required.sum { |i| i[:price] }
  end
end
