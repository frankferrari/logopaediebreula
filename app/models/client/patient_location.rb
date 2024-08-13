module Client
  class PatientLocation < ApplicationRecord
    belongs_to :patient, class_name: 'Client::Patient'
    belongs_to :location, class_name: 'Shared::Location'

    validates :patient_id, uniqueness: { scope: :location_id }
  end
end
