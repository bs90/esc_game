class UserItem < ApplicationRecord
  belongs_to :user, foreign_key: :user_id
  belongs_to :item

  validates :user_id, presence: true
  validates :item_id, presence: true
  validates :user_id, uniqueness: { scope: :item_id, message: "User already has this item" }
end
