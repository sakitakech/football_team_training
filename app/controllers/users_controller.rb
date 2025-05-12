class UsersController < ApplicationController
  before_action :authenticate_user!

  def new
    @user = User.new
  end

  def index
    if current_user.team_id.present?
      @q = User.ransack(params[:q])
      @users = @q.result
                 .includes(:position)
                 .where(team_id: current_user.team_id)
                 .order("positions.id", "users.id")

      @users_grouped = @users.group_by(&:position)

      if current_user.admin?
        @pending_requests = TeamJoinRequest
          .includes(:user)
          .where(team_id: current_user.team_id, status: :pending)
      end

      @team_members = User.where(team_id: current_user.team_id).order(:position_id, :last_name)
    else
      # チーム未所属ユーザーのアクセス制限 or 表示内容を調整
      redirect_to root_path, alert: "チームに所属していません"
      nil
    end
  end

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to @user, notice: "プロフィールを更新しました。"
    else
      render :edit
    end
  end

  def remove_from_team
    user = User.find(params[:id])

    unless current_user.admin?
      redirect_to users_path, alert: "権限がありません"
      return
    end

    user.update(team_id: nil)
    redirect_to users_path, notice: "#{user.full_name} さんをチームから外しました"
  end






  def leave_team
    if current_user.admin? && only_one_admin?(current_user)
      redirect_to user_path(current_user), alert: "チームに1人しか管理者がいないため、チームを脱退できません。"
      return
    end

    if current_user.update(team_id: nil)
      redirect_to root_path, notice: "チームを脱退しました"
    else
      redirect_to request.referer || root_path, alert: "脱退に失敗しました"
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :position_id, :introduction)
  end


end
