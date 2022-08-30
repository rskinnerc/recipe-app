class RecipesController < ApplicationController
  load_and_authorize_resource

  def index
    @recipes = Recipe.where(user: current_user).all
  end

  def show; end

  def new
  end

  def destroy
    @recipe.destroy
    redirect_to recipes_path
  end
end
