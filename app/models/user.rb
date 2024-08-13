class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :employee, class_name: 'Employee::Employee'
  has_one :client, class_name: 'Client::Client'

  def employee?
    employee.present?
  end

  def client?
    client.present?
  end
end
