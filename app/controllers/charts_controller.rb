class ChartsController < ApplicationController
  def index
    @team_members = current_user.team.users
    @max_weights = MaxWeight.all
  end
end
