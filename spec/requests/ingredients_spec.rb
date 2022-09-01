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
      get "/recipes/#{@first.id}/ingredients/new"
      expect(response).to have_http_status(:success)
    end

    it 'raises an AccessDenied error if the user is not the owner of the recipe' do
      sign_in @user2
      expect { get "/recipes/#{@first.id}/ingredients/new" }.to raise_error(CanCan::AccessDenied)
    end

    it 'redirects to the login page path if the user is not authenticated' do
      get "/recipes/#{@first.id}/ingredients/new"
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'renders the new template if the user is authenticated and is the owner of the recipe' do
      sign_in @user
      get "/recipes/#{@first.id}/ingredients/new"
      expect(response).to render_template('new')
    end

    it "should list the current user's ingredients (foods) that are not part of a the recipe's ingredients" do
      sign_in @user
      get "/recipes/#{@first.id}/ingredients/new"
      expect(response.body).to include('Test Ingredient')
      expect(response.body).to include('Test Ingredient 2')
      expect(response.body).to_not include('Test Ingredient 3')
    end

    it 'should have a link to add an ingredient for the user' do
      sign_in @user
      get "/recipes/#{@first.id}/ingredients/new"
      expect(response.body).to include('href="/foods/new"')
      expect(response.body).to include('Do not have an ingredient yet? Add one now!')
    end
  end
end
