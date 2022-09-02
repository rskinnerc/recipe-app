require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with valid attributes' do
    expect(User.new(email: 'some@user.com', password: 'password')).to be_valid
  end
end
