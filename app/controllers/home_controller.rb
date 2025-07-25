class HomeController < ApplicationController
  before_action :require_current_user, except: :index

  def index
    if current_user
      @qr_url = "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=https://sunesc.heasygame.online/touch/#{current_user.id}"
    end
  end

  def touch
    return redirect_to root_path unless touched_user = User.find_by_id(params[:id])
    Touch.create_touch! current_user, touched_user
    redirect_to root_path
  end

  def notifications
    @notifications = Notification.all.order(created_at: :desc)
  end

  def scanner
  end

  def list_items
    @items = Item.all.left_joins(:user_items).where("user_items.user_id = ? OR user_items.user_id IS NULL", @current_user.id)
  end

  private
  def require_current_user
    return redirect_to root_path unless current_user&.id
  end
end
