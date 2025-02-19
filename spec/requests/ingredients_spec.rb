require 'rails_helper'

RSpec.describe 'Ingredients', type: :request do
  before(:all) do
    @user = User.create!(name: 'Test User', email: 'ingredients@email.com', password: 'password')
    @user2 = User.create!(name: 'Test User 2', email: 'ingredients2@email.com', password: 'password')
    @first = Recipe.create!(name: 'Test Recipe', description: 'Test Description', public: false, cooking_time: 60,
                            preparation_time: 60, user: @user)
    @food = Food.create!(name: 'Test Ingredient', measurement_unit: 'grams', user: @user)
    @food2 = Food.create!(name: 'Test Ingredient 2', measurement_unit: 'grams', user: @user)
    @food3 = Food.create!(name: 'Test Ingredient 3', measurement_unit: 'grams', user: @user)
    @first.foods << @food3
  end

  describe 'GET /recipe/:id/ingredients/new' do
    it 'returns http success if the user is authenticated and is the owner of the recipe' do
      sign_in @user
      get new_recipe_ingredient_path(@first)
      expect(response).to have_http_status(:success)
    end

    it 'raises an AccessDenied error if the user is not the owner of the recipe' do
      sign_in @user2
      expect { get new_recipe_ingredient_path(@first) }.to raise_error(CanCan::AccessDenied)
    end

    it 'redirects to the login page path if the user is not authenticated' do
      get new_recipe_ingredient_path(@first)
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'renders the new template if the user is authenticated and is the owner of the recipe' do
      sign_in @user
      get new_recipe_ingredient_path(@first)
      expect(response).to render_template('new')
    end

    it "should list the current user's ingredients (foods) that are not part of a the recipe's ingredients" do
      sign_in @user
      get new_recipe_ingredient_path(@first)
      expect(response.body).to include('Test Ingredient')
      expect(response.body).to include('Test Ingredient 2')
      expect(response.body).to_not include('Test Ingredient 3')
    end

    it 'should have a link to add an ingredient for the user' do
      sign_in @user
      get new_recipe_ingredient_path(@first)
      expect(response.body).to include('href="/foods/new"')
      expect(response.body).to include('Do not have an ingredient yet? Add one now!')
    end
  end

  describe 'POST /recipe/:id/ingredients' do
    it 'raises an AccessDenied error if the user is not the owner of the recipe' do
      sign_in @user2
      expect { post recipe_ingredients_path(@first) }.to raise_error(CanCan::AccessDenied)
    end

    it 'redirects to the login page path if the user is not authenticated' do
      post recipe_ingredients_path(@first)
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'should have a foods array in the params hash' do
      sign_in @user
      expect { post recipe_ingredients_path(@first) }.to raise_error(ActionController::ParameterMissing)
    end

    it "should add the ingredient if checked to the recipe's ingredients " do
      sign_in @user
      post recipe_ingredients_path(@first),
           params: { foods: [{ checked: '1', food_id: @food.id, quantity: '10' },
                             { food_id: @food2.id, quantity: '10' }] }
      expect(@first.foods.count).to eq(2)
    end

    it 'should redirect the user to the recipe details after adding he ingredients' do
      sign_in @user
      post recipe_ingredients_path(@first),
           params: { foods: [{ checked: '1', food_id: @food.id, quantity: '10' },
                             { food_id: @food2.id, quantity: '10' }] }
      expect(response).to redirect_to(recipe_path(@first))
    end

    it "should add the ingredient to the recipe's ingredients" do
      sign_in @user
      post recipe_ingredients_path(@first),
           params: { foods: [{ checked: '1', food_id: @food.id, quantity: '10' },
                             { checked: '1', food_id: @food2.id, quantity: '10' }] }
      expect(@first.foods.count).to eq(3)
    end
  end

  describe 'DELETE /recipe/:id/ingredients/:id' do
    it 'raises an AccessDenied error if the user is not the owner of the recipe' do
      sign_in @user2
      expect { delete recipe_ingredient_path(@first, @food3) }.to raise_error(CanCan::AccessDenied)
    end

    it 'redirects to the login page path if the user is not authenticated' do
      delete recipe_ingredient_path(@first, @food3)
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'should remove the ingredient from the recipe' do
      sign_in @user
      delete recipe_ingredient_path(@first, @food3)
      expect(@first.foods.count).to eq(0)
    end

    it 'should redirect the user to the recipe details after removing the ingredient' do
      sign_in @user
      delete recipe_ingredient_path(@first, @food3)
      expect(response).to redirect_to(recipe_path(@first))
    end
  end
end
