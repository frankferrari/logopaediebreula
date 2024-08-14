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

  # Test for exclusive association
  describe 'exclusive association' do
    context 'when user is already associated with a client' do
      let(:user) { create(:user, :client) }

      it 'cannot be associated with an employee' do
        employee = build(:employee, user:)
        expect(employee).not_to be_valid
        expect(employee.errors[:user]).to include('is already associated with a client')
      end
    end

    context 'when user is already associated with an employee' do
      let(:user) { create(:user, :employee) }

      it 'cannot be associated with a client' do
        client = build(:client, user:)
        expect(client).not_to be_valid
        expect(client.errors[:user]).to include('is already associated with an employee')
      end
    end

    # Test for switching associations
    describe 'User exclusive association' do
      context 'when switching from client to employee' do
        let(:user) { create(:user, :client) }

        it 'destroys the existing client association' do
          user.client.destroy
          user.reload
          expect(user.client).to be_nil
        end

        it 'creates a new employee association' do
          user.client.destroy
          user.reload
          create(:employee, user:)
          user.reload
          expect(user.employee).to be_a(Employee::Employee)
        end

        it 'ensures the client association is nil after switching' do
          user.client.destroy
          user.reload
          create(:employee, user:)
          user.reload
          expect(user.client).to be_nil
        end
      end

      context 'when switching from employee to client' do
        let(:user) { create(:user, :employee) }

        it 'destroys the existing employee association' do
          user.employee.destroy
          user.reload
          expect(user.employee).to be_nil
        end

        it 'creates a new client association' do
          user.employee.destroy
          user.reload
          create(:client, user:)
          user.reload
          expect(user.client).to be_a(Client::Client)
        end

        it 'ensures the employee association is nil after switching' do
          user.employee.destroy
          user.reload
          create(:client, user:)
          user.reload
          expect(user.employee).to be_nil
        end
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
