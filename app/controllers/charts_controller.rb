class ChartsController < ApplicationController
  def index
    if current_user.team_id.present?
      @team_members = User.where(team_id: current_user.team_id).order(:last_name, :first_name)
      @grouped_members = User
        .includes(:position)
        .where(team_id: current_user.team_id)
        .order("positions.id ASC", "last_name ASC")
        .group_by(&:position)
    else
      @team_members = []
      @grouped_members = {}
    end

    @max_weights = MaxWeight.all
    @selected_user_id = params[:user_id].to_i if params[:user_id].present?

    @user_position_map = @team_members.map { |u| [ u.id, u.position_id ] }.to_h
  end
end
