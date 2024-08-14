FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password123' }
    password_confirmation { 'password123' }

    trait :client do
      after(:create) do |user|
        create(:client, user:)
      end
    end

    trait :employee do
      after(:create) do |user|
        create(:employee, user:)
      end
    end

    factory :client_user, traits: [:client]
    factory :employee_user, traits: [:employee]
  end
end
