class Employee::EmployeesFocusareas < ApplicationRecord
  belongs_to :employee, class_name: 'Employee::Employee'
  belongs_to :focusarea, class_name: 'Shared::Focusarea'

  validates :employee_id, uniqueness: { scope: :focusarea_id }
end