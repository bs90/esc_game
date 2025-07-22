class User < ApplicationRecord
  has_many :user_items, dependent: :destroy
  has_many :items, through: :user_items

  def touch_count
    Touch.where("touched_user_id = :id OR touch_user_id = :id", id: id).count
  end

  def unread_notifications_count
    Notification.where("id > ?", self.last_read_notification_id || 0).count
  end
end
