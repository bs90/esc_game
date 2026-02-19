class Room < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :clear_room_histories, dependent: :destroy
  has_many :teams, through: :clear_room_histories
end

