class Team < ApplicationRecord
  has_many :users, dependent: :nullify
  has_many :point_histories, dependent: :destroy
  has_many :clear_room_histories, dependent: :destroy
  has_many :rooms, through: :clear_room_histories
  has_many :team_items, dependent: :destroy
  has_many :items, through: :team_items
  validates :name, presence: true
  validates :current_points, presence: true
  validates :current_points, numericality: { greater_than_or_equal_to: 0 }
  validates :current_points, numericality: { only_integer: true }
end

