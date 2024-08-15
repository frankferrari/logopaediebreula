class RenameJoinTablesToPlural < ActiveRecord::Migration[7.1]
  def change
    rename_table :employee_focusareas, :employees_focusareas
    rename_table :employee_languages, :employees_languages
    rename_table :employee_locations, :employees_locations
    rename_table :patient_locations, :patients_locations
    rename_table :patient_languages, :patients_languages
  end
end