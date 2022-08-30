class FoodController < ApplicationController
  def Index
    @foods = Food.all
    @user = User.find(params[:user_id])
  end

  def new
  end
end
