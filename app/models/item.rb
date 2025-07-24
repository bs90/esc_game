class Item < ApplicationRecord
  has_many :user_items, dependent: :destroy
  has_many :users, through: :user_items
  after_create :generate_token

  validates :name, presence: true
  validates :category, presence: true
  validates :token, uniqueness: true

  def generate_token
    self.token = SecureRandom.uuid
    self.save
  end
end
