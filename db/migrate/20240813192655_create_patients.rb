class CreatePatients < ActiveRecord::Migration[7.1]
  def change
    create_table :patients do |t|
      t.string :patient_first_name, null: false
      t.string :patient_last_name, null: false
      t.date :date_of_birth, null: false
      t.integer :gender, null: false
      t.boolean :has_prescription, null: false
      t.integer :health_insurance, null: false
      t.text :diagnosis, null: false
      t.string :kita_name
      t.boolean :has_i_status
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end