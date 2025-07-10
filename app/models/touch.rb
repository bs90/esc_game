class Touch < ApplicationRecord
  belongs_to :touch_user, class_name: 'User', foreign_key: 'touch_user_id'
  belongs_to :touched_user, class_name: 'User', foreign_key: 'touched_user_id'

  def self.create_touch! touch_user, touched_user
    return if touch_user.nil? || touched_user.nil?
    return if touch_user.id == touched_user.id
    return if self.exists?(touch_user: touch_user, touched_user: touched_user)
    return if self.exists?(touched_user: touch_user, touch_user: touched_user)

    self.create!(
      touch_user: touch_user,
      touched_user: touched_user
    )
  end
end
