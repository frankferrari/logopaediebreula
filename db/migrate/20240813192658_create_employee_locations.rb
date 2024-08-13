class CreateEmployeeLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :employee_locations do |t|
      t.references :employee, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true

      t.timestamps
    end

    add_index :employee_locations, [:employee_id, :location_id], unique: true
  end
end