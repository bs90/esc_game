class CreateTableItems < ActiveRecord::Migration[8.0]
  def change
    create_table :items do |t|
      t.timestamps
      t.string :name
      t.string :category
      t.string :image_url
    end
  end
end
