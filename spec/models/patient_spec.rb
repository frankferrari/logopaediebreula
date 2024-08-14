require 'rails_helper'

RSpec.describe Client::Patient, type: :model do
  # Associations
  describe 'associations' do
    it { is_expected.to belong_to(:client).class_name('Client::Client') }
    it { is_expected.to have_many(:patient_languages).class_name('Client::PatientLanguage') }
    it { is_expected.to have_many(:languages).through(:patient_languages).class_name('Shared::Language') }
    it { is_expected.to have_many(:patient_locations).class_name('Client::PatientLocation') }
    it { is_expected.to have_many(:locations).through(:patient_locations).class_name('Shared::Location') }
  end

  # Validations
  describe 'validations' do
    it { is_expected.to validate_presence_of(:patient_first_name) }
    it { is_expected.to validate_presence_of(:patient_last_name) }
    it { is_expected.to validate_presence_of(:date_of_birth) }
    it { is_expected.to validate_presence_of(:gender) }
    it { is_expected.to validate_presence_of(:health_insurance) }
    it { is_expected.to validate_presence_of(:diagnosis) }
    it { is_expected.to validate_inclusion_of(:has_prescription).in_array([true, false]) }

    it { is_expected.to define_enum_for(:gender).with_values(male: 0, female: 1, other: 2) }
    it { is_expected.to define_enum_for(:health_insurance).with_values(publicly: 0, privately: 1) }
  end
end
