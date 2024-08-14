module Client
  class Client < ApplicationRecord
    belongs_to :user
    has_many :patients, class_name: 'Client::Patient', dependent: :destroy

    validates :user, presence: true
    validates :address, presence: true
    validates :phone_number, presence: true, format: { with: /\A\+?[\d\s()-]+\z/, message: 'invalid format' }

    validate :user_not_associated_with_employee

    private

  end
end
