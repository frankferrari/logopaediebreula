class CreatePatientLanguages < ActiveRecord::Migration[7.1]
  def change
    create_table :patient_languages do |t|
      t.references :patient, null: false, foreign_key: true
      t.references :language, null: false, foreign_key: true

      t.timestamps
    end

    add_index :patient_languages, [:patient_id, :language_id], unique: true, name: 'index_patient_profile_languages_uniqueness'
  end
end