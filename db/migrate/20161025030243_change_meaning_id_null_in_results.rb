class ChangeMeaningIdNullInResults < ActiveRecord::Migration[5.0]
  def change
    change_column_null :results, :meaning_id, true

    add_column :lessons, :is_finished, :boolean, default: false
  end
end
