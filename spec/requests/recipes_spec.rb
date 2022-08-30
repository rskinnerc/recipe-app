require 'rails_helper'

RSpec.describe 'Recipes', type: :request do
  before(:all) do
    @user = User.create!(name: 'Test User', email: 'test@email.com', password: 'password')
    @user2 = User.create!(name: 'Test User 2', email: 'test2@email.com', password: 'password')
    @first = Recipe.create!(name: 'Test Recipe', description: 'Test Description', public: false, cooking_time: 60,
                            preparation_time: 60, user: @user)
    @second = Recipe.create!(name: 'Test Recipe 2', description: 'Test Description', public: true, cooking_time: 60,
                             preparation_time: 60, user: @user)
    Recipe.create!(name: 'Test Recipe 3', description: 'Test Description', public: 0, cooking_time: 60,
                   preparation_time: 60, user: @user)
    Recipe.create!(name: 'Test Recipe 4', description: 'Test Description', public: 0, cooking_time: 60,
                   preparation_time: 60, user: @user2)
  end

  describe 'GET /recipes' do
    it 'returns http success' do
      sign_in @user
      get '/recipes'
      expect(response).to have_http_status(:success)
    end

    it 'renders the index template' do
      sign_in @user
      get '/recipes'

      expect(response).to render_template('index')
    end

    it 'should display all recipes created by the current user' do
      sign_in @user
      get '/recipes'

      expect(response.body).to include('Test Recipe')
      expect(response.body).to include('Test Recipe 2')
      expect(response.body).to include('Test Recipe 3')
      expect(response.body).to_not include('Test Recipe 4')
    end
  end

  describe 'GET /recipes/:id' do
    it 'returns http success if the user is the owner' do
      sign_in @user
      get recipe_path(@first)
      expect(response).to have_http_status(:success)
    end

    it 'should raise an AccessDenied error if the is not the owner and the recipe is not public' do
      sign_in @user2
      expect { get recipe_path(@first) }.to raise_error(CanCan::AccessDenied)
    end

    it 'returns http success if the user is not the owner and the recipe IS public' do
      sign_in @user2
      get recipe_path(@second)
      expect(response).to have_http_status(:success)
    end

    it 'renders the show template when the user can access the recipe details page' do
      sign_in @user
      get recipe_path(@first)

      expect(response).to render_template('show')
    end

    it 'should display the recipe details when the user can access the recipe details page' do
      sign_in @user
      get recipe_path(@first)

      expect(response.body).to include('Test Recipe')
      expect(response.body).to include('Test Description')
      expect(response.body).to include('60')
      expect(response.body).to include('60')
    end

    it 'should contain a link to the form for adding ingredients if the user is the owner' do
      sign_in @user
      get recipe_path(@first)
      expect(response.body).to include('Add Ingredient')
    end

    it 'should NOT contain a link to the form for adding ingredients if the user is NOT the owner' do
      sign_in @user2
      get recipe_path(@second)
      expect(response.body).to_not include('Add Ingredient')
    end
  end

  describe 'DELETE /recipes/:id' do
    it 'should raises a AccessDenied error when the user hasn\'t signed in' do
      expect { delete recipe_path(@first) }.to raise_error(CanCan::AccessDenied)

      expect(Recipe.exists?(@first.id)).to be(true)
    end

    it 'should raises a AccessDenied error when the user is not the owner of the recipe' do
      sign_in @user
      expect { delete recipe_path(Recipe.last) }.to raise_error(CanCan::AccessDenied)

      expect(Recipe.last.destroyed?).to be(false)
    end

    it 'should delete the recipe when the user is the owner of the recipe and redirect to te recipes_path' do
      sign_in @user
      delete recipe_path(@first)
      expect(response).to redirect_to(recipes_path)
      expect(Recipe.exists?(@first.id)).to be(false)
    end
  end

  describe 'GET /recipes/new' do
    it 'should raise an AccessDenied error if the user hasn\'t signed in' do
      expect { get new_recipe_path }.to raise_error(CanCan::AccessDenied)
    end

    it 'should render the new template if the user is signed in' do
      sign_in @user
      get new_recipe_path
      expect(response).to render_template('new')
    end

    it 'should display a form for creating a new recipe' do
      sign_in @user
      get new_recipe_path
      expect(response.body).to include('<form')
    end
  end

  describe 'POST /recipes' do
    subject {Recipe.new(
        name: 'Test Recipe',
        description: 'Test Description',
        public: false,
        cooking_time: 60,
        preparation_time: 60
      )}

    it 'should raise an AccessDenied error if the user hasn\'t signed in' do
      expect { post recipes_path, params: { recipe: subject.attributes } }.to raise_error(CanCan::AccessDenied)
    end

    it 'should create a new recipe if the user is signed in and redirect him to the new recipe details' do
      sign_in @user
      expect { post recipes_path, params: { recipe: subject.attributes } }.to change(Recipe, :count).by(1)
      expect(response).to redirect_to(recipe_path(Recipe.last))
    end
  end
end
