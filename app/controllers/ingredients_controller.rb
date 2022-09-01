class IngredientsController < ApplicationController
  before_action :authenticate_user!

  def new
    @recipe = Recipe.find(params[:recipe_id])
    authorize! :manage, @recipe
    @ingredients = current_user.foods.where.not(id: @recipe.food_ids)
  end
end
