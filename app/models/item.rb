class Item < ApplicationRecord
  has_many :user_items, dependent: :destroy
  has_many :users, through: :user_items
  before_create :generate_token

  validates :name, presence: true
  validates :category, presence: true
  validates :token, uniqueness: true

  scope :list_items, -> (user_id) do
    select([
      'items.name as name',
      'items.category as category',
      'items.image_url as image_url',
      'items.token as token',
      'items.numerical_order as numerical_order',
      'CASE WHEN user_items.user_id IS NOT NULL THEN true ELSE false END as is_collected',
    ].join(','))
    .joins(
      <<~SQL.squish
        LEFT OUTER JOIN "user_items"
        ON "user_items"."item_id" = "items"."id"
        AND "user_items"."user_id" = '#{user_id}'
      SQL
    )
    .order('items.numerical_order ASC')
  end

  def generate_token
    self.token = SecureRandom.uuid
  end
end
