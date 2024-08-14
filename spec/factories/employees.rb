FactoryBot.define do
  factory :employee do
    user
    employee_first_name { Faker::Name.first_name }
    employee_last_name { Faker::Name.last_name }
    date_of_birth { Faker::Date.birthday(min_age: 18, max_age: 65) }
    short_description { Faker::Lorem.paragraph }
    long_description { Faker::Lorem.paragraphs(number: 3).join("\n\n") }
    is_admin { false }

    trait :admin do
      is_admin { true }
    end
  end
end
