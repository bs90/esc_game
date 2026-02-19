class TeamItem < ApplicationRecord
  belongs_to :team
  belongs_to :item

  validates :team_id, presence: true
  validates :item_id, presence: true
  validates :team_id, uniqueness: { scope: :item_id, message: "Team already has this item" }
end

