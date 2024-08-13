module Client
  class Client < ApplicationRecord
    belongs_to :user
    has_many :patients, class_name: 'Client::Patient'

    validates :address, presence: true
    validates :phone_number, presence: true, format: { with: /\A\+?[\d\s()-]+\z/, message: 'invalid format' }
  end
end
