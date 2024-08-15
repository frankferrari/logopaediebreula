require 'rails_helper'

RSpec.describe Client::Patient, type: :model do
  context 'when user is a Patient' do
    let(:patient) { create(:patient, :with_languages, :with_locations) }
    subject { patient }
  
    describe 'associations' do
      it { should belong_to(:user) }
      it { should belong_to(:client).class_name('Client::Client') }  
      it { should have_many(:patients_languages).class_name('Client::PatientsLanguages') }
      it { should have_many(:languages).through(:patients_languages).class_name('Shared::Languages') }
      it { should have_many(:patients_locations).class_name('Client::PatientsLocations') }
      it { should have_many(:locations).through(:patients_locations).class_name('Shared::Locations') }
    end

    describe 'validations' do
      it { should validate_presence_of(:patient_first_name) }
      it { should validate_presence_of(:patient_last_name) }
      it { should validate_presence_of(:date_of_birth) }
      it { should validate_presence_of(:gender) }
      it { should validate_presence_of(:health_insurance) }
      it { should validate_presence_of(:diagnosis) }
      it { should validate_inclusion_of(:has_prescription).in_array([true, false]) }
    end

    describe 'enums' do
      it { should define_enum_for(:gender).with_values(male: 0, female: 1, other: 2) }
      it { should define_enum_for(:health_insurance).with_values(publicly: 0, privately: 1) }
    end

    describe 'custom validations' do
      it 'should not allow date_of_birth in the future' do
        patient = build(:patient, date_of_birth: Date.tomorrow)
        expect(patient).not_to be_valid
        expect(patient.errors[:date_of_birth]).to include("can't be in the future")
      end
    end
  end
end