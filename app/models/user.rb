class User < ApplicationRecord
  def touch_count
    Touch.where("touched_user_id = :id OR touch_user_id = :id", id: id).count
  end
end
