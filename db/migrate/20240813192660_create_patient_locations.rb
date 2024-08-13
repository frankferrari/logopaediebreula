class CreatePatientLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :patient_locations do |t|
      t.references :patient, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true

      t.timestamps
    end

    add_index :patient_locations, [:patient_id, :location_id], unique: true, name: 'index_patient_profile_locations_uniqueness'
  end
end