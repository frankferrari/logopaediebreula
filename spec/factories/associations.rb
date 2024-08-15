FactoryBot.define do
  factory :employees_focusareas, class: 'Employee::EmployeesFocusareas' do
    employee
    focusarea
  end

  factory :employees_languages, class: 'Employee::EmployeesLanguages' do
    employee
    language
  end

  factory :employees_locations, class: 'Employee::EmployeesLocations' do
    employee
    location
  end

  factory :patients_languages, class: 'Client::PatientsLanguages' do
    patient
    language
  end

  factory :patients_locations, class: 'Client::PatientsLocations' do
    patient
    location
  end

  factory :focusarea, class: 'Shared::Focusarea' do
    name { Faker::Job.field }
  end

  factory :language, class: 'Shared::Language' do
    name { Faker::ProgrammingLanguage.name }
  end

  factory :location, class: 'Shared::Location' do
    name { Faker::Address.city }
  end
end