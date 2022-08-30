class RecipesController < ApplicationController
  def index
    @recipes = Recipe.where(user: current_user).all
  end

  def show
    @recipe = Recipe.find(params[:id])
  end
end
