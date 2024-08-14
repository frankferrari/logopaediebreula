FactoryBot.define do
  # Guard clause to prevent redefinition
  return if FactoryBot.factories.registered?(:user)

  factory :user do
    email { Faker::Internet.email }
    password { 'Password123!' }
    password_confirmation { 'Password123!' }

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
