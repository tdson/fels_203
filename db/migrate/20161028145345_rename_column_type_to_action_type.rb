class RenameColumnTypeToActionType < ActiveRecord::Migration[5.0]
  def change
    rename_column :activities, :type, :action_type
    remove_column :lessons, :scores
  end
end
