class CreateTeamItems < ActiveRecord::Migration[8.0]
  def change
    create_table :team_items do |t|
      t.references :team, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.datetime :got_at
      t.timestamps
    end
  end
end
