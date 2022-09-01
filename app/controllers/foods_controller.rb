class FoodsController < ApplicationController
  before_action :authenticate_user!

  def index
    @foods = current_user.foods
  end

  def new; end

  def create
    @food = current_user.foods.build(food_params)

    if @food.save
      if session[:recipe_id].nil?
        redirect_to foods_path
      else
        redirect_to recipe_path(session[:recipe_id])
      end
    else
      render :new
    end
  end

  def destroy
    @food = current_user.foods.find(params[:id])
    @food.destroy
    redirect_to foods_path, notice: 'Food was successfully destroyed.'
  end

  private

  def food_params
    params.require(:food).permit(:name, :measurement_unit, :price, :quantity)
  end
end
