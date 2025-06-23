class CreateCards < ActiveRecord::Migration[8.0]
  def change
    create_table :cards do |t|
      t.references :column, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.integer :position, null: false, default: 0

      t.timestamps
    end
  end
end
