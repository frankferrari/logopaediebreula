FactoryBot.define do
  factory :client, class: 'Client::Client' do
    user
    client_first_name { Faker::Name.first_name }
    client_last_name { Faker::Name.last_name }
    address { Faker::Address.full_address }
    phone_number { Faker::PhoneNumber.phone_number }
  end
end