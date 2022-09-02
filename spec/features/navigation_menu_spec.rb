require 'rails_helper'

RSpec.feature 'NavigationMenus', type: :feature do
  scenario 'Not authenticated users can see the navigation menu with public links' do
    visit root_path
    expect(page).to have_link 'Public Recipes'
    expect(page).to have_selector '#logo'
    expect(page).to have_link 'Login'
    expect(page).to have_link 'Sign Up'
  end

  scenario 'Authenticated users can see the navigation menu with private links' do
    user = User.create!(name: 'Test User', email: 'test@email.com', password: 'password')
    sign_in user
    visit root_path
    expect(page).to have_link 'Public Recipes'
    expect(page).to have_selector '#logo'
    expect(page).to have_link 'My Recipes'
    expect(page).to have_link 'My Foods'
    expect(page).to_not have_link 'Login'
  end
end
