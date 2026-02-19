class Item < ApplicationRecord
  belongs_to :room
  has_many :team_items, dependent: :destroy
  has_many :teams, through: :team_items
  before_create :generate_token

  validates :name, presence: true
  validates :token, uniqueness: true

  scope :list_items, -> (team_id) do
    select([
      'items.id as id',
      'items.name as name',
      'items.description as description',
      'items.points as points',
      'items.image_url as image_url',
      'items.token as token',
      'items.numerical_order as numerical_order',
      'CASE WHEN team_items.team_id IS NOT NULL THEN true ELSE false END as is_collected',
    ].join(','))
    .joins(
      <<~SQL.squish
        LEFT OUTER JOIN "team_items"
        ON "team_items"."item_id" = "items"."id"
        AND "team_items"."team_id" = '#{team_id}'
      SQL
    )
    .order('items.numerical_order ASC')
  end

  def generate_token
    self.token = SecureRandom.uuid
  end
end
