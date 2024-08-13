class CreateEmployeeAofs < ActiveRecord::Migration[7.1]
  def change
    create_table :employee_aofs do |t|
      t.references :employee, null: false, foreign_key: true
      t.references :aof, null: false, foreign_key: true

      t.timestamps
    end

    add_index :employee_aofs, [:employee_id, :aof_id], unique: true
  end
end