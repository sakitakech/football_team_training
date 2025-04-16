class UsersController < ApplicationController
  before_action :authenticate_user!

  def new
    @user = User.new
  end

  def index
    @positions = Position.includes(:users).where(users: { team_id: current_user.team_id }).order(:id)
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
