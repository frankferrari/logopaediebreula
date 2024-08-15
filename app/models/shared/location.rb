module Shared
  class Location < ApplicationRecord
    has_many :employee_locations, class_name: 'Employee::EmployeesLocations'
    has_many :employees, through: :employee_locations, class_name: 'Employee::Employee'
    has_many :patient_locations, class_name: 'Client::PatientsLocations'
    has_many :patients, through: :patient_locations, class_name: 'Client::Patient'

    validates :name, presence: true, uniqueness: true
  end
end
