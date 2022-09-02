class IngredientsController < ApplicationController
  before_action :authenticate_user!

  def new
    @recipe = Recipe.find(params[:recipe_id])
    authorize! :manage, @recipe
    @ingredients = current_user.foods.where.not(id: @recipe.food_ids)
    session[:recipe_id] = @recipe.id
  end

  def create
    @recipe = Recipe.find(params[:recipe_id])
    authorize! :manage, @recipe
    foods = params.require(:foods)
    if @recipe.recipe_foods.create(foods.map do |food|
                                     unless food[:checked].nil? || food[:quantity].to_i.zero?
                                       { food_id: food[:food_id], quantity: food[:quantity] }
                                     end
                                   end)
      redirect_to recipe_path(@recipe)
    else
      render 'ingredients/new'
    end
  end

  def destroy
    @recipe = Recipe.find(params[:recipe_id])
    authorize! :manage, @recipe
    @recipe.recipe_foods.find_by(food_id: params[:id]).destroy
    redirect_to recipe_path(@recipe)
  end
end
