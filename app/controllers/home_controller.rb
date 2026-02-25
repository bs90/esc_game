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
    team_id = current_user.team_id
    if team_id.blank?
      redirect_to root_path, alert: "You are not in a team" # will fix after rooms and teams is implemented
    else
      @items = Item.list_items(team_id)
    end
  end

  def list_rooms
    @rooms = Room.all
                 .left_joins(clear_room_histories: :team)
                 .includes(clear_room_histories: :team)
                 .distinct
  end

  def show_room
    @room = Room.includes(clear_room_histories: :team).find(params[:id])
    # Load items ordered by numerical_order
    @items = @room.items.order(:numerical_order)
    # Preload team_items for current user's team to check if items are collected
    if current_user&.team_id.present?
      @team_items = TeamItem.where(team_id: current_user.team_id, item_id: @items.pluck(:id)).pluck(:item_id)
    else
      @team_items = []
    end
  end

  private
  def require_current_user
    return redirect_to root_path unless current_user&.id
  end
end
