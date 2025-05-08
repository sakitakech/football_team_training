class UsersController < ApplicationController
  before_action :authenticate_user!

  def new
    @user = User.new
  end

  def index
    @q = User.ransack(params[:q])
    @users = @q.result
               .includes(:position)
               .where(team_id: current_user.team_id)
               .order("positions.id", "users.id")

    @users_grouped = @users.group_by(&:position)

    if current_user.admin? && current_user.team_id.present?
      @pending_requests = TeamJoinRequest
        .includes(:user)
        .where(team_id: current_user.team_id, status: :pending)
    end
  
    @team_members = User.where(team_id: current_user.team_id).order(:position_id, :last_name)
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

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :position_id, :introduction)
  end
end
