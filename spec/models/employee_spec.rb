require 'rails_helper'

RSpec.describe Employee::Employee, type: :model do

  describe 'valid factory check' do
    it 'has a valid factory' do
      expect(build(:employee)).to be_valid
    end
  end

  context 'when user is a employee' do
    let(:employee) { create(:employee, :with_focusareas, :with_languages, :with_locations) }

    subject { employee }

    describe 'in terms of associations it' do
      it { should belong_to(:user) }
      it { should have_many(:employees_focusareas).class_name('Employee::EmployeesFocusareas') }
      it { should have_many(:focusareas).through(:employees_focusareas).class_name('Shared::Focusarea') }
      it { should have_many(:employees_languages).class_name('Employee::EmployeesLanguages') }
      it { should have_many(:languages).through(:employees_languages).class_name('Shared::Language') }
      it { should have_many(:employees_locations).class_name('Employee::EmployeesLocations') }
      it { should have_many(:locations).through(:employees_locations).class_name('Shared::Location') }
    end

    describe 'in terms of validations it' do
      it { should validate_presence_of(:employee_first_name) }
      it { should validate_presence_of(:employee_last_name) }
      it { should validate_presence_of(:date_of_birth) }
    end

    describe 'in terms of custom validations it' do
      it 'should not allow date_of_birth in the future' do
        employee = build(:employee, date_of_birth: Date.tomorrow)
        expect(employee).not_to be_valid
        expect(employee.errors[:date_of_birth]).to include("can't be in the future")
      end
    end
  end
end
