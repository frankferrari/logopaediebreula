class Client::PatientsLanguages < ApplicationRecord
  belongs_to :patient, class_name: 'Client::Patient'
  belongs_to :language, class_name: 'Shared::Language'

  validates :patient_id, uniqueness: { scope: :language_id }
end