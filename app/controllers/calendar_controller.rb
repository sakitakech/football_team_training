class CalendarController < ApplicationController
  def index
    @positions = Position.all
    @team_members = User.where(team_id: current_user.team_id).order(:last_name, :first_name)
  end
end
