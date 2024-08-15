
class RenameAofToFocusarea < ActiveRecord::Migration[7.1]
  def change
    rename_table :aofs, :focusareas
    rename_column :employee_aofs, :aof_id, :focusarea_id
    rename_table :employee_aofs, :employee_focusareas
  end
end