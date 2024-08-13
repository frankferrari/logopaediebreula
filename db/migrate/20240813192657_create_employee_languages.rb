class CreateEmployeeLanguages < ActiveRecord::Migration[7.1]
  def change
    create_table :employee_languages do |t|
      t.references :employee, null: false, foreign_key: true
      t.references :language, null: false, foreign_key: true

      t.timestamps
    end

    add_index :employee_languages, [:employee_id, :language_id], unique: true
  end
end