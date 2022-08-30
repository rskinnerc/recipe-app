require 'rails_helper'

RSpec.describe Recipe, type: :model do
  subject do
    user = User.create(name: 'Test User')
    described_class.new(user:, name: 'Test Recipe', description: 'Test Description', preparation_time: 60,
                        cooking_time: 70, public: true)
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

  it 'is not valid without a description' do
    subject.description = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without a preparation time' do
    subject.preparation_time = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without a cooking time' do
    subject.cooking_time = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid with a preparation time less than 0' do
    subject.preparation_time = -1
    expect(subject).to_not be_valid
  end

  it 'is not valid with a cooking time less than 0' do
    subject.cooking_time = -1
    expect(subject).to_not be_valid
  end
end
