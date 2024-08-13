module Shared
  class Aof < ApplicationRecord
    has_many :employee_aofs, class_name: 'Employee::EmployeeAof'
    has_many :employees, through: :employee_aofs, class_name: 'Employee::Employee'

    validates :name, presence: true, uniqueness: true
  end
end
