class UpdateItems < ActiveRecord::Migration[8.0]
  def change
    add_column :items, :points, :integer
    add_column :items, :description, :string
    remove_column :items, :category
    add_reference :items, :room, foreign_key: true
  end
end
