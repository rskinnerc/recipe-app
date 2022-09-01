require 'rails_helper'

RSpec.describe 'Foods', type: :request do
  before(:all) do
    @user = User.create!(name: 'Test User', email: 'foods@email.com', password: 'password')
    @food = Food.create!(name: 'Test Food', measurement_unit: 'grams', user: @user)
    @food = Food.create!(name: 'Test Food 2', measurement_unit: 'grams', user: @user)
    @food = Food.create!(name: 'Test Food 3', measurement_unit: 'grams', user: @user)
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
end
