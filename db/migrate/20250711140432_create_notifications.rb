class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.text :content, null: false
      t.timestamps
    end
    add_column :users, :last_read_notification_id, :integer
  end
end
