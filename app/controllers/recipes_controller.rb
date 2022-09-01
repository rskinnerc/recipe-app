class RecipesController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  load_and_authorize_resource

  def index
    @recipes = current_user.recipes.includes(:user)
  end

  def show; end

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
