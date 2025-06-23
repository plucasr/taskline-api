class CreateBoardMemberships < ActiveRecord::Migration[8.0]
  def change
    create_table :board_memberships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :board, null: false, foreign_key: true
      t.integer :role, null: false, default: 0

      t.timestamps
    end
    add_index :board_memberships, %i[user_id board_id], unique: true
  end
end
