require 'rails_helper'

RSpec.describe Client::Client, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:patients).class_name('Client::Patient').dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:phone_number) }
    it { should allow_value('+1 (123) 456-7890').for(:phone_number) }
    it { should_not allow_value('invalid phone').for(:phone_number) }
  end
end