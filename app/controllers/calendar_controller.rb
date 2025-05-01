class CalendarController < ApplicationController
  def index
    @positions = Position.all
    @team_members = User.where(team_id: current_user.team_id).order(:last_name, :first_name)
    @grouped_members = User
      .includes(:position)
      .where(team_id: current_user.team_id)
      .order("positions.id ASC", "last_name ASC")
      .group_by(&:position)

    @selected_user_id = params[:user_id].to_i if params[:user_id].present?
    @user_position_map = @team_members.map { |u| [ u.id, u.position_id ] }.to_h
  end
end
