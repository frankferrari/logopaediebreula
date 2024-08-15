FactoryBot.define do
  factory :patient, class: 'Client::Patient' do
    association :client, factory: :client, strategy: :create
    patient_first_name { Faker::Name.first_name }
    patient_last_name { Faker::Name.last_name }
    date_of_birth { Faker::Date.birthday(min_age: 1, max_age: 100) }
    gender { Client::Patient.genders.keys.sample }
    has_prescription { [true, false].sample }
    health_insurance { Client::Patient.health_insurances.keys.sample }
    diagnosis { Faker::Lorem.sentence }
    kita_name { Faker::Company.name }
    has_i_status { [true, false].sample }

    trait :with_languages do
      transient do
        languages_count { 2 }
      end

      after(:create) do |patient, evaluator|
        create_list(:patients_languages, evaluator.languages_count, patient: patient)
      end
    end

    trait :with_locations do
      transient do
        locations_count { 2 }
      end

      after(:create) do |patient, evaluator|
        create_list(:patients_locations, evaluator.locations_count, patient: patient)
      end
    end
  end
end