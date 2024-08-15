class Employee::EmployeesLanguages < ApplicationRecord
  belongs_to :employee, class_name: 'Employee::Employee'
  belongs_to :language, class_name: 'Shared::Language'

  validates :employee_id, uniqueness: { scope: :language_id }
end