class TeamsController < ApplicationController
  before_action :require_current_user

  def index
    @rooms = Room.order(:id).limit(4)
    @teams = Team.includes(:clear_room_histories).order(:id)
  end

  def show
    @team = Team.includes(:clear_room_histories, :users).find(params[:id])
    if current_user.team_id != @team.id
      redirect_to teams_path, alert: "You can only view your own team details."
      return
    end

    @rooms = Room.order(:id).limit(4)
    @point_histories = @team.point_histories.order(created_at: :desc)
    @members = @team.users.order(:name, :email)
  end

  private

  def require_current_user
    return if current_user&.id

    redirect_to root_path
  end
end
