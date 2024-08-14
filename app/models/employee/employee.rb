module Employee
  class Employee < ApplicationRecord
    belongs_to :user
    has_many :employee_aofs, class_name: 'Employee::EmployeeAof'
    has_many :aofs, through: :employee_aofs, class_name: 'Shared::Aof'
    has_many :employee_languages, class_name: 'Employee::EmployeeLanguage'
    has_many :languages, through: :employee_languages, class_name: 'Shared::Language'
    has_many :employee_locations, class_name: 'Employee::EmployeeLocation'
    has_many :locations, through: :employee_locations, class_name: 'Shared::Location'

    validates :employee_first_name, presence: true
    validates :employee_last_name, presence: true
    validates :date_of_birth, presence: true
    validate :date_of_birth_not_in_future

    validate :user_not_associated_with_client

    private

    def user_not_associated_with_client
      return unless user.client.present?

      errors.add(:user, 'is already associated with a client')
    end

    def date_of_birth_not_in_future
      return unless date_of_birth.present? && date_of_birth > Date.today

      errors.add(:date_of_birth, "can't be in the future")
    end
  end
end
