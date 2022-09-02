class RecipesController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  load_and_authorize_resource

  def index
    @recipes = current_user.recipes.includes(:user)
  end

  def show
    @recipe = Recipe.find(params[:id])
    @ingredients = @recipe.recipe_foods.includes(:food).map do |recipe_food|
      { name: recipe_food.food.name, quantity: recipe_food.quantity,
        price: recipe_food.quantity * recipe_food.food.price, food_id: recipe_food.food_id }
    end
    session[:recipe_id] = nil
  end

  def new; end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user = current_user
    if @recipe.save
      redirect_to @recipe
    else
      render 'new'
    end
  end

  def destroy
    @recipe.destroy
    redirect_to recipes_path
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :description, :preparation_time, :cooking_time, :public)
  end
end
