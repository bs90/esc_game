class AddReferenceUsersToTeams < ActiveRecord::Migration[8.0]
  def change
    add_reference :users, :team, foreign_key: true, null: true, default: nil
  end
end
