class CreateClients < ActiveRecord::Migration[7.1]
  def change
    create_table :clients do |t|
      t.references :user, null: false, foreign_key: true
      t.string :client_first_name
      t.string :client_last_name
      t.string :address, null: false
      t.string :phone_number, null: false

      t.timestamps
    end
  end
end