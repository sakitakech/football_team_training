class ChartsController < ApplicationController
  def index
    @team_members =
      if current_user.team_id.present?
         User.where(team_id: current_user.team_id).order(:last_name, :first_name)
      else
        []
      end
    @max_weights = MaxWeight.all
  end
end
