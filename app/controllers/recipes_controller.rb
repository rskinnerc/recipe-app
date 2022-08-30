class RecipesController < ApplicationController
  def index
    @recipes = Recipe.where(user: current_user).all
  end
end
