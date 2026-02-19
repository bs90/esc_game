class CreateClearRoomHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :clear_room_histories do |t|
      t.references :room, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.timestamps
    end
  end
end
