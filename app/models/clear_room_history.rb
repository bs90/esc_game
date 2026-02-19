class ClearRoomHistory < ApplicationRecord
  belongs_to :room
  belongs_to :team

  validates :room_id, presence: true
  validates :team_id, presence: true
end

