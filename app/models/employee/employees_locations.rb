class Employee::EmployeesLocations < ApplicationRecord
  belongs_to :employee, class_name: 'Employee::Employee'
  belongs_to :location, class_name: 'Shared::Location'

  validates :employee_id, uniqueness: { scope: :location_id }
end