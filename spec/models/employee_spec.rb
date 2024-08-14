require 'rails_helper'

RSpec.describe Employee::Employee, type: :model do
  # Associations
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:employee_aofs).class_name('Employee::EmployeeAof') }
    it { is_expected.to have_many(:aofs).through(:employee_aofs).class_name('Shared::Aof') }
    it { is_expected.to have_many(:employee_languages).class_name('Employee::EmployeeLanguage') }
    it { is_expected.to have_many(:languages).through(:employee_languages).class_name('Shared::Language') }
    it { is_expected.to have_many(:employee_locations).class_name('Employee::EmployeeLocation') }
    it { is_expected.to have_many(:locations).through(:employee_locations).class_name('Shared::Location') }
  end

  # Validations
  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:employee_first_name) }
    it { is_expected.to validate_presence_of(:employee_last_name) }
    it { is_expected.to validate_presence_of(:date_of_birth) }
  end

  # Custom validations
  describe 'custom validations' do
    it 'does not allow date_of_birth in the future' do
      employee = build(:employee, date_of_birth: Date.tomorrow)
      expect(employee).not_to be_valid
      expect(employee.errors[:date_of_birth]).to include("can't be in the future")
    end
  end
end
