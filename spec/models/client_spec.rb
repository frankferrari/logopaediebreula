require 'rails_helper'

RSpec.describe Client::Client, type: :model do
  # Associations
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:patients).class_name('Client::Patient').dependent(:destroy) }
  end

  # Validations
  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:address) }
    it { is_expected.to validate_presence_of(:phone_number) }
    it { is_expected.to allow_value('+1 (123) 456-7890').for(:phone_number) }
    it { is_expected.not_to allow_value('invalid phone').for(:phone_number) }
  end

end
