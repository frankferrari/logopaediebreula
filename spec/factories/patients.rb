FactoryBot.define do
  # Guard clause to prevent redefinition
  return if FactoryBot.factories.registered?(:patient)

  factory :patient, class: 'Client::Patient' do
    client
    patient_first_name { Faker::Name.first_name }
    patient_last_name { Faker::Name.last_name }
    date_of_birth { Faker::Date.birthday(min_age: 1, max_age: 18) }
    gender { Client::Patient.genders.keys.sample }
    has_prescription { [true, false].sample }
    health_insurance { Client::Patient.health_insurances.keys.sample }
    diagnosis { Faker::Lorem.sentence }
    kita_name { Faker::Company.name }
    has_i_status { [true, false].sample }
  end
end
