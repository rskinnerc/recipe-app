Rails.application.routes.draw do
  
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root to: "recipes#index"
  resources :recipes, only: [:index, :show, :new, :create, :destroy] do
    resources :ingredients, only: [:new, :create]
  end
  resources :foods, only: [:index, :show, :new, :create, :destroy]
  resources :public_recipes, only: [:index]
end
