class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :employee, class_name: 'Employee::Employee', dependent: :destroy
  has_one :client, class_name: 'Client::Client', dependent: :destroy

  def employee?
    employee.present?
  end

  def client?
    client.present?
  end
end
