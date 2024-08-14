require 'rails_helper'

RSpec.describe User, type: :model do
  # Test for valid factory
  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:user)).to be_valid
    end
  end

  # Test for Devise modules
  describe 'Devise modules' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_length_of(:password).is_at_least(8) }
  end

  # Test for associations
  describe 'associations' do
    it { is_expected.to have_one(:employee).class_name('Employee::Employee').dependent(:destroy) }
    it { is_expected.to have_one(:client).class_name('Client::Client').dependent(:destroy) }
  end

  # Test for user type logic
  describe 'user type' do
    context 'when user is a client' do
      let(:user) { create(:user, :client) }

      it 'is associated with a client' do
        expect(user.client).to be_a(Client::Client)
      end

      it 'is not associated with an employee' do
        expect(user.employee).to be_nil
      end

      it 'returns true for client?' do
        expect(user.client?).to be true
      end

      it 'returns false for employee?' do
        expect(user.employee?).to be false
      end
    end

    context 'when user is an employee' do
      let(:user) { create(:user, :employee) }

      it 'is associated with an employee' do
        expect(user.employee).to be_a(Employee::Employee)
      end

      it 'is not associated with a client' do
        expect(user.client).to be_nil
      end

      it 'returns false for client?' do
        expect(user.client?).to be false
      end

      it 'returns true for employee?' do
        expect(user.employee?).to be true
      end
    end
  end

  # Test for deletion behavior
  describe 'deletion behavior' do
    context 'when user is a client' do
      let!(:user) { create(:user, :client) }
      let!(:patient) { create(:patient, client: user.client) }

      it 'deletes associated client when user is deleted' do
        expect { user.destroy }.to change(Client::Client, :count).by(-1)
      end

      it 'deletes associated patients when user is deleted' do
        expect { user.destroy }.to change(Client::Patient, :count).by(-1)
      end
    end

    context 'when user is an employee' do
      let!(:user) { create(:user, :employee) }

      it 'deletes associated employee when user is deleted' do
        expect { user.destroy }.to change(Employee::Employee, :count).by(-1)
      end
    end
  end
end
