class CreateMeanings < ActiveRecord::Migration[5.0]
  def change
    create_table :meanings do |t|
      t.references :word, foreign_key: true
      t.string :content
      t.boolean :is_correct

      t.timestamps
    end
  end
end
