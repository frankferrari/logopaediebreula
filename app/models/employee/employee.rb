module Employee
end

class Employee::Employee < ApplicationRecord
  belongs_to :user
  has_many :employee_focusareas, class_name: 'Employee::EmployeesFocusareas'
  has_many :focusareas, through: :employee_focusareas, class_name: 'Shared::Focusarea'

  has_many :employee_languages, class_name: 'Employee::EmployeesLanguages'
  has_many :languages, through: :employee_languages, class_name: 'Shared::Language'
  
  has_many :employee_locations, class_name: 'Employee::EmployeesLocations'
  has_many :locations, through: :employee_locations, class_name: 'Shared::Location'

  validates :employee_first_name, presence: true
  validates :employee_last_name, presence: true
  validates :date_of_birth, presence: true
  validate :date_of_birth_not_in_future

  private

  def date_of_birth_not_in_future
    return unless date_of_birth.present? && date_of_birth > Date.today
    errors.add(:date_of_birth, "can't be in the future")
  end
end
