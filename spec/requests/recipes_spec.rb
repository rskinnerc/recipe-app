require 'rails_helper'

RSpec.describe 'Recipes', type: :request do
  before do
    @user = User.create!(name: 'Test User', email: 'test@email.com', password: 'password')
    @user2 = User.create!(name: 'Test User 2', email: 'test2@email.com', password: 'password')
    sign_in @user
    Recipe.create!(name: 'Test Recipe', description: 'Test Description', public: 0, cooking_time: 60,
                   preparation_time: 60, user: @user)
    Recipe.create!(name: 'Test Recipe 2', description: 'Test Description', public: 0, cooking_time: 60,
                   preparation_time: 60, user: @user)
    Recipe.create!(name: 'Test Recipe 3', description: 'Test Description', public: 0, cooking_time: 60,
                   preparation_time: 60, user: @user)
    Recipe.create!(name: 'Test Recipe 4', description: 'Test Description', public: 0, cooking_time: 60,
                   preparation_time: 60, user: @user2)
  end

  describe 'GET /recipes' do
    it 'returns http success' do
      get '/recipes'
      expect(response).to have_http_status(:success)
    end

    it 'renders the index template' do
      get '/recipes'
      expect(response).to render_template('index')
    end

    it 'should display all recipes created by the current user' do
      get '/recipes'
      expect(response.body).to include('Test Recipe')
      expect(response.body).to include('Test Recipe 2')
      expect(response.body).to include('Test Recipe 3')
      expect(response.body).to_not include('Test Recipe 4')
    end
  end

  describe 'GET /recipes/:id' do
    it 'returns http success' do
      get recipe_path(Recipe.first)
      expect(response).to have_http_status(:success)
    end

    it 'renders the show template' do
      get recipe_path(Recipe.first)
      expect(response).to render_template('show')
    end

    it 'should display the recipe details' do
      get recipe_path(Recipe.first)
      expect(response.body).to include('Test Recipe')
      expect(response.body).to include('Test Description')
      expect(response.body).to include('60')
      expect(response.body).to include('60')
    end
  end
end
