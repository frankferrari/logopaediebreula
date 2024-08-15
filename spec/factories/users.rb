FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password123' }
    password_confirmation { 'password123' }

    trait :with_employee do
      after(:create) do |user|
        create(:employee, user: user)
      end
    end

    trait :with_client do
      after(:create) do |user|
        create(:client, user: user)
      end
    end
  end
end