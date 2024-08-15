class Client::Patient < ApplicationRecord
  belongs_to :client, class_name: 'Client::Client'
  has_many :patient_languages, class_name: 'Client::PatientLanguage'
  has_many :languages, through: :patient_languages, class_name: 'Shared::Language'
  has_many :patient_locations, class_name: 'Client::PatientLocation'
  has_many :locations, through: :patient_locations, class_name: 'Shared::Location'

  enum gender: { male: 0, female: 1, other: 2 }
  enum health_insurance: { publicly: 0, privately: 1 }

  validates :patient_first_name, presence: true
  validates :patient_last_name, presence: true
  validates :date_of_birth, presence: true
  validates :gender, presence: true
  validates :has_prescription, inclusion: { in: [true, false] }
  validates :health_insurance, presence: true
  validates :diagnosis, presence: true
  validate :date_of_birth_not_in_future

  private

  def date_of_birth_not_in_future
    return unless date_of_birth.present? && date_of_birth > Date.today
    errors.add(:date_of_birth, "can't be in the future")
  end
end