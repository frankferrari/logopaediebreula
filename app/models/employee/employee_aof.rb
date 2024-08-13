module Employee
  class EmployeeAof < ApplicationRecord
    belongs_to :employee, class_name: 'Employee::Employee'
    belongs_to :aof, class_name: 'Shared::Aof'

    validates :employee_id, uniqueness: { scope: :aof_id }
  end
end
