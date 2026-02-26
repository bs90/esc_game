module Admin
  class ItemsController < Admin::ApplicationController
    # Override `resource_params` to handle room_id from query params
    # This allows pre-filling room_id when creating item from room show page
    def resource_params
      params = super
      # If room_id is passed as query param (from room show page), use it
      if params && params[:room_id].present?
        params[:room_id] = params[:room_id]
      elsif request.query_parameters[:room_id].present?
        params ||= {}
        params[:room_id] = request.query_parameters[:room_id]
      end
      params
    end

    def sell
      item = Item.find(params[:item_id])
      team = Team.find(params[:team_id])

      # Check if team already has this item
      if TeamItem.exists?(team_id: team.id, item_id: item.id)
        redirect_back(fallback_location: admin_rooms_path, alert: "Team already has this item")
        return
      end

      # Create TeamItem association
      TeamItem.create!(
        team: team,
        item: item,
        got_at: Time.current
      )

      # Add points to team if item has points
      team.update!(current_points: team.current_points - item.points)

      # Create point history record
      PointHistory.create!(
        team: team,
        points: 0 - item.points,
        description: "Sold item: #{item.name} - #{item.points} points"
      )

      redirect_back(fallback_location: admin_rooms_path, notice: "Item '#{item.name}' sold to #{team.name} successfully")
    rescue ActiveRecord::RecordNotFound => e
      redirect_back(fallback_location: admin_rooms_path, alert: "Item or team not found")
    rescue StandardError => e
      redirect_back(fallback_location: admin_rooms_path, alert: "Error selling item: #{e.message}")
    end

    # See https://administrate-demo.herokuapp.com/customizing_controller_actions
    # for more information
  end
end
