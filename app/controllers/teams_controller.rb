class TeamsController < ApplicationController
  before_action :ensure_admin!
  skip_before_action :redirect_admin_to_team_creation, only: [ :new, :create ]

  def new
    @team = Team.new
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
    @team = current_user.team
  end

  def edit
    @team = current_user.team
  end

  def update
    @team = current_user.team
    if @team.update(team_params)
      redirect_to team_path, notice: "チーム情報を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if current_user.admin? && current_user.team_id.present?
      team = Team.find_by(id: current_user.team_id)

      if team.present?
        User.where(team_id: team.id).update_all(team_id: nil, role: "member")
        team.destroy
        redirect_to root_path, notice: "チームを削除しました。全員が無所属になりました。"
      else
        redirect_to root_path, alert: "エラーが起きました。"
      end
    else
      redirect_to root_path, alert: "この操作は許可されていません。"
    end
  end

  def confirm_destroy
    @team = Team.find(params[:id])

    unless current_user.admin? && current_user.team_id == @team.id
      redirect_to root_path, alert: "この操作は許可されていません。"
    end
  end

  private
  def ensure_admin!
    unless user_signed_in? && current_user.admin?
      redirect_to root_path, alert: "管理者のみアクセスできます"
    end
  end

  def team_params
    params.require(:team).permit(:name, :league_id)
  end
end
