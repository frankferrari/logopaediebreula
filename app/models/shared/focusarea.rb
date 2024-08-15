module Shared
  class Focusarea < ApplicationRecord
    has_many :employees_focusareas, class_name: 'Employee::EmployeesFocusareas'
    has_many :employees, through: :employee_focusareas, class_name: 'Employee::Employee'

    validates :name, presence: true, uniqueness: true
  end
end