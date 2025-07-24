class CreateTableUserItems < ActiveRecord::Migration[8.0]
  def change
    create_table :user_items do |t|
      t.timestamps
      t.string :user_id
      t.bigint :item_id
      t.datetime :got_at
    end
  end
end
