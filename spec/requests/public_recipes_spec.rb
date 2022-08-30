require 'rails_helper'

RSpec.describe 'PublicRecipes', type: :request do
  before(:all) do
    @user = User.create!(name: 'Test User 3', email: 'test3@email.com', password: 'password')
    @first = Recipe.create!(name: 'Test Recipe 1', description: 'Test Description', public: false, cooking_time: 60,
                            preparation_time: 60, user: @user)
    @second = Recipe.create!(name: 'Test Recipe 2', description: 'Test Description', public: true, cooking_time: 60,
                             preparation_time: 60, user: @user)
    Recipe.create!(name: 'Test Recipe 3', description: 'Test Description', public: true, cooking_time: 60,
                   preparation_time: 60, user: @user)
    Recipe.create!(name: 'Test Recipe 4', description: 'Test Description', public: false, cooking_time: 60,
                   preparation_time: 60, user: @user)
  end
  describe 'GET /' do
    it 'returns http success' do
      get public_recipes_path
      expect(response).to have_http_status(:success)
    end

    it 'renders the index template' do
      get public_recipes_path
      expect(response).to render_template('index')
    end

    it 'should display all public recipes from newest to oldest' do
      get public_recipes_path
      expect(response.body).to include('Test Recipe 3')
      expect(response.body).to include('Test Recipe 2')
      expect(response.body).to_not include('Test Recipe 1')
      expect(response.body).to_not include('Test Recipe 4')
    end
  end
end
