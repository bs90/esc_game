class User < ApplicationRecord
  belongs_to :team, optional: true
  before_validation :normalize_email
  validates :email, uniqueness: { case_sensitive: false }, allow_blank: true

  def touch_count
    Touch.where("touched_user_id = :id OR touch_user_id = :id", id: id).count
  end

  def unread_notifications_count
    Notification.where("id > ?", self.last_read_notification_id || 0).count
  end

  private

  def normalize_email
    self.email = email.to_s.strip.downcase if respond_to?(:email=)
  end
end
