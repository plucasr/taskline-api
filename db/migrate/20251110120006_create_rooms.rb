class CreateRooms < ActiveRecord::Migration[8.0]
  def change
    create_table :rooms do |t|
      t.references :board, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
