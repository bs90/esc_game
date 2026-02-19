class RemoveUserItems < ActiveRecord::Migration[8.0]
  def change
    drop_table :user_items
  end
end
