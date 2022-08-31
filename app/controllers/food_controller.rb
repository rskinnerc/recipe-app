class FoodController < ApplicationController
  def create
    food = Food.new(food_params)
    food.user_id = params[:user_id]

    if food.save
      redirect_to user_foods_path(params[:user_id])
    else
      redirect_to new_user_food_path
    end
  end

  def destroy; end

  def food_params
    params.require(:food).permit(:name, :measurement_unit, :price, :quantity)
  end
end
