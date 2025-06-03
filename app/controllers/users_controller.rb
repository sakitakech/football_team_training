class UsersController < ApplicationController
  before_action :authenticate_user!, except: [ :complete_profile, :update_profile ]
  before_action :set_user_from_session, only: [ :complete_profile, :update_profile ]

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

    if current_user.update(team_id: nil, role: "member")
      redirect_to root_path, notice: "チームを脱退しました"
    else
      redirect_to request.referer || root_path, alert: "脱退に失敗しました"
    end
  end

  def promote_admin
    authorize_admin_action!
    user = User.find(params[:id])

    if admin_count_for_team >= 5
      redirect_to users_path, alert: "このチームにはすでに5人の管理者がいます。"
      return
    end

    if user.update(role: "admin")
      redirect_to users_path, notice: "#{user.last_name} を管理者に昇格させました"
    else
      redirect_to users_path, alert: "昇格に失敗しました"
    end
  end

  def self_promote_admin
    if current_user.role == "member" && current_user.team_id.nil?
      current_user.update(role: "admin")
      redirect_to new_team_path
    else
      redirect_to root_path, alert: "エラーが起きました。"
    end
  end

  def transfer_admin
    authorize_admin_action!
    user = User.find(params[:id])

    ActiveRecord::Base.transaction do
      current_user.update!(role: "member")
      user.update!(role: "admin")
    end

    redirect_to users_path, notice: "管理者権限を #{user.last_name} に譲渡しました"
  rescue => e
    redirect_to users_path, alert: "譲渡に失敗しました: #{e.message}"
  end

  def demote_admin
    if current_user.admin?
      if current_user.only_one_admin?
        redirect_to users_path, alert: "管理者が1人しかいないため、降格できません。"
      else
        current_user.update(role: "member")
        redirect_to users_path, notice: "あなたは管理者を降りました。"
      end
    else
      redirect_to root_path, alert: "この操作は許可されていません。"
    end
  end

  def complete_profile
    @user = User.find(session[:user_id])
  end

  def update_profile
    @user = User.find(session[:user_id])

    unless @user.update(user_params)
      render :complete_profile, status: :unprocessable_entity and return
    end

    session.delete(:user_id)
    sign_in(@user)
    redirect_to root_path, notice: "プロフィールが更新されました。"
  end

  private

  def set_user_from_session
    @user = User.find_by(id: session[:user_id])
    unless @user
      redirect_to root_path, alert: "不正なアクセスです。"
    end
  end

  def admin_count_for_team
    User.where(team_id: current_user.team_id, role: "admin").count
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :position_id, :password, :password_confirmation, :introduction)
  end

  def only_one_admin?(user)
    User.where(team_id: current_user.team_id, role: "admin").count == 1
  end
end
