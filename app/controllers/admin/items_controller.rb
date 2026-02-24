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

    # See https://administrate-demo.herokuapp.com/customizing_controller_actions
    # for more information
  end
end
