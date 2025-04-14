class TeamsController < ApplicationController
  before_action :ensure_admin!


  def new
  end

  def create
    @team = Team.new(team_params)
    if @team.save
      current_user.update(team_id: @team.id)
      redirect_to trainings_path, notice: "チームを作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
  
  private
  def ensure_admin!
    unless user_signed_in? && current_user.admin?
      redirect_to root_path, alert: "管理者のみアクセスできます"
    end
  end

end
