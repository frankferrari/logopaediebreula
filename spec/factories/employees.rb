FactoryBot.define do
  factory :employee, class: 'Employee::Employee' do
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

    trait :with_focusareas do
      transient do
        focusareas_count { 2 }
      end

      after(:create) do |employee, evaluator|
        create_list(:employees_focusareas, evaluator.focusareas_count, employee: employee)
      end
    end

    trait :with_languages do
      transient do
        languages_count { 2 }
      end

      after(:create) do |employee, evaluator|
        create_list(:employees_languages, evaluator.languages_count, employee: employee)
      end
    end

    trait :with_locations do
      transient do
        locations_count { 2 }
      end

      after(:create) do |employee, evaluator|
        create_list(:employees_locations, evaluator.locations_count, employee: employee)
      end
    end
  end
end