require 'rails_helper'

RSpec.describe 'Foods', type: :request do
  before(:all) do
    @user = User.create!(name: 'Test User', email: 'foods@email.com', password: 'password')
    @food = Food.create!(name: 'Test Food', measurement_unit: 'grams', user: @user)
    @food2 = Food.create!(name: 'Test Food 2', measurement_unit: 'grams', user: @user)
    @food3 = Food.create!(name: 'Test Food 3', measurement_unit: 'grams', user: @user)
  end

  describe 'GET /foods' do
    it 'redirects to the login page when the user is not authenticated' do
      get foods_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns http success when the user is autenticated' do
      sign_in @user
      get foods_path
      expect(response).to have_http_status(:success)
    end

    it 'renders the index template' do
      sign_in @user
      get foods_path
      expect(response).to render_template('index')
    end

    it 'should display all foods the current user has' do
      sign_in @user
      get foods_path
      expect(response.body).to include('Test Food')
      expect(response.body).to include('Test Food 2')
      expect(response.body).to include('Test Food 3')
    end
  end

  describe 'GET /foods/new' do
    it 'redirects to the login page when the user is not authenticated' do
      get new_food_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns http success when the user is autenticated' do
      sign_in @user
      get new_food_path
      expect(response).to have_http_status(:success)
    end

    it 'renders the new template and shows the Add Food title' do
      sign_in @user
      get new_food_path
      expect(response).to render_template('new')
      expect(response.body).to include('Add Food')
    end
  end

  describe 'POST /foods' do
    subject do
      Food.new(
        name: 'Test Recipe',
        measurement_unit: 'grams',
        price: 1,
        quantity: 1
      )
    end

    it 'redirects to the login page when the user is not authenticated' do
      post foods_path, params: { recipe: subject.attributes }
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'should create a new food if the user is signed in and redirect him to the foods list' do
      sign_in @user
      expect { post foods_path, params: { food: subject.attributes } }.to change(Food, :count).by(1)
      expect(response).to redirect_to(foods_path)
    end
  end

  describe 'DELETE /foods/:id' do
    it 'redirects to the login page when the user is not authenticated' do
      delete food_path(@food)
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'should delete the food if the user is signed in and redirect him to the foods list' do
      sign_in @user
      expect { delete food_path(@food) }.to change(Food, :count).by(-1)
      expect(response).to redirect_to(foods_path)
    end
  end
end
