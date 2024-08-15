module Shared
  class Language < ApplicationRecord
    has_many :employee_languages, class_name: 'Employee::EmployeesLanguages'
    has_many :employees, through: :employee_languages, class_name: 'Employee::Employee'
    has_many :patient_languages, class_name: 'Client::PatientsLanguages'
    has_many :patients, through: :patient_languages, class_name: 'Client::Patient'

    validates :name, presence: true, uniqueness: true
  end
end