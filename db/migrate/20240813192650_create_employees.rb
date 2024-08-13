class CreateEmployees < ActiveRecord::Migration[7.1]
  def change
    create_table :employees do |t|
      t.references :user, null: false, foreign_key: true
      t.string :employee_first_name, null: false
      t.string :employee_last_name, null: false
      t.date :date_of_birth
      t.text :short_description
      t.text :long_description
      t.boolean :is_admin, default: false

      t.timestamps
    end
  end
end