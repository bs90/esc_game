class CreatePointHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :point_histories do |t|
      t.integer :points
      t.string :description
      t.references :team, null: false, foreign_key: true
      t.timestamps
    end
  end
end
