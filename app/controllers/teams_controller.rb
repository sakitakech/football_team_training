class TeamsController < ApplicationController
  before_action :ensure_admin!
  before_action :redirect_admin_to_team_creation

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

  def redirect_admin_to_team_creation
    return unless user_signed_in?
    return unless current_user.admin?
    return if current_user.team_id.present?

    # チーム作成ページ以外でのみリダイレクト
    unless request.path == new_team_path
      redirect_to new_team_path, alert: "まずはチームを作成してください"
    end
  end

end
