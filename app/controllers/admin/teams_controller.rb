module Admin
  class TeamsController < Admin::ApplicationController
    def create
      resource = new_resource(resource_params)
      authorize_resource(resource)

      ActiveRecord::Base.transaction do
        resource.save!
        sync_members!(resource)
      end

      redirect_to(
        after_resource_created_path(resource),
        notice: translate_with_resource("create.success")
      )
    rescue ActiveRecord::RecordInvalid
      render :new, locals: {
        page: Administrate::Page::Form.new(dashboard, resource)
      }, status: :unprocessable_entity
    end

    def update
      ActiveRecord::Base.transaction do
        requested_resource.update!(resource_params)
        sync_members!(requested_resource)
      end

      redirect_to(
        after_resource_updated_path(requested_resource),
        notice: translate_with_resource("update.success"),
        status: :see_other
      )
    rescue ActiveRecord::RecordInvalid
      render :edit, locals: {
        page: Administrate::Page::Form.new(dashboard, requested_resource)
      }, status: :unprocessable_entity
    end

    def add_points
      team = requested_resource
      points = params[:points].to_i
      reason = params[:reason].to_s.strip

      if points.zero?
        redirect_to admin_team_path(team), alert: "AP must be different from 0."
        return
      end

      if reason.blank?
        redirect_to admin_team_path(team), alert: "Reason cannot be blank."
        return
      end

      ActiveRecord::Base.transaction do
        team.update!(current_points: team.current_points + points)
        PointHistory.create!(team: team, points: points, description: reason)
      end

      redirect_to admin_team_path(team), notice: "AP was updated successfully."
    rescue ActiveRecord::RecordInvalid => e
      redirect_to admin_team_path(team), alert: e.record.errors.full_messages.to_sentence
    end

    private

    def member_user_ids
      raw = params.dig(resource_class.model_name.param_key, :member_user_ids)
      return [] if raw.blank?

      raw.filter_map do |id|
        normalized = id.to_s.strip
        normalized if normalized.present?
      end.uniq
    end

    def sync_members!(team)
      user_ids = member_user_ids
      selected_users = user_ids.empty? ? User.none : User.where(id: user_ids)
      known_ids = selected_users.pluck(:id).map(&:to_s)
      requested_ids = user_ids.map(&:to_s)
      missing_ids = requested_ids - known_ids
      if missing_ids.any?
        team.errors.add(:base, "Users not found: #{missing_ids.join(', ')}")
        raise ActiveRecord::RecordInvalid, team
      end

      if requested_ids.empty?
        User.where(team_id: team.id).update_all(team_id: nil)
      else
        User.where(team_id: team.id).where.not(id: known_ids).update_all(team_id: nil)
      end

      selected_users.find_each do |user|
        next if user.team_id == team.id

        user.update!(team_id: team.id)
      end
    end
  end
end
