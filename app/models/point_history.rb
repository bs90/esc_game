class PointHistory < ApplicationRecord
  belongs_to :team

  validates :points, presence: true
  validates :description, presence: true
end

