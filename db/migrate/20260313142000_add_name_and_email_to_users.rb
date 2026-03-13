class AddNameAndEmailToUsers < ActiveRecord::Migration[8.0]
  def up
    add_column :users, :name, :string unless column_exists?(:users, :name)
    add_column :users, :email, :string unless column_exists?(:users, :email)
    add_index :users, :email, unique: true unless index_exists?(:users, :email)
  end

  def down
    remove_index :users, :email if index_exists?(:users, :email)
    remove_column :users, :email if column_exists?(:users, :email)
    remove_column :users, :name if column_exists?(:users, :name)
  end
end
