class CreateTouchesTable < ActiveRecord::Migration[8.0]
  def change
    create_table :touches do |t|
      t.string :touch_user_id
      t.string :touched_user_id

      t.timestamps
    end
  end
end
