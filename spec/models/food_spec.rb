require 'rails_helper'

RSpec.describe Food, type: :model do
  subject do
    user = User.create(name: 'Test User')
    described_class.new(user:, name: 'Test Food', measurement_unit: 'grams', price: 1,
                        quantity: 1)
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without a user' do
    subject.user = nil
    expect(subject).to_not be_valid
  end

  it 'should belong to a user' do
    expect(subject.user).to_not be_nil
  end

  it 'is not valid without a name' do
    subject.name = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without a measurement unit' do
    subject.measurement_unit = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without a quantity' do
    subject.quantity = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without a price' do
    subject.price = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid with a price less than 0' do
    subject.price = -1
    expect(subject).to_not be_valid
  end

  it 'is not valid with a quantity less than 0' do
    subject.quantity = -1
    expect(subject).to_not be_valid
  end

  it 'should have many recipes' do
    expect(subject).to respond_to(:recipes)
  end

  it 'should have many recipes_foods' do
    expect(subject).to respond_to(:recipe_foods)
  end

  it 'should have many recipes through recipe_foods' do
    expect(subject.recipes).to_not be_nil
  end
end
