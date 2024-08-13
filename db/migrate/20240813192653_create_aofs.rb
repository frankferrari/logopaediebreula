class CreateAofs < ActiveRecord::Migration[7.1]
  def change
    create_table :aofs do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end