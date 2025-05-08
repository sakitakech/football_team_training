class TeamJoinRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!

  def new
    @invite = InviteToken.find_by(token: params[:token])

    if @invite.nil? || @invite.expires_at < Time.current
      redirect_to root_path, alert: "この招待リンクは期限切れです"
      return
    end

    @token = @invite.token

    # 仮の参加リクエストオブジェクト（Structで作る）
    @join_request = Struct.new(:message, keyword_init: true).new

    # 空のオブジェクト作成

  end

  def create
    token = params[:token]
    team = Team.find_by(invite_token: token)

    unless team
      redirect_to root_path, alert: "招待リンクが無効または期限切れです"
      return
    end

    if current_user.team_id.present?
      redirect_to root_path, alert: "すでにチームに所属しています"
      return
    end

    existing = TeamJoinRequest.where(user: current_user, team: team, status: :pending).exists?
    if existing
      redirect_to root_path, notice: "すでに申請中です"
      return
    end

    @join_request = TeamJoinRequest.new(
      user: current_user,
      team: team,
      message: params[:team_join_request][:message],
      status: :pending,
      expires_at: 12.hours.from_now
    )

    if @join_request.save
      redirect_to root_path, notice: "参加申請を送信しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
   @pending_requests = TeamJoinRequest.where(team_id: current_user.team_id, status: "pending").includes(:user)
  end

  def update
    @request = TeamJoinRequest.find(params[:id])

    if params[:decision] == "approve"
      @request.user.update!(team_id: @request.team_id)
      @request.update!(status: :approved)
      flash[:notice] = "#{@request.user.full_name}さんをチームに追加しました"
    elsif params[:decision] == "reject"
      @request.update!(status: :rejected)
      flash[:alert] = "#{@request.user.full_name}さんの参加を拒否しました"
    else
      flash[:alert] = "無効な操作です"
    end

    redirect_to users_path
  end


  private

  def require_admin!
    redirect_to root_path, alert: "権限がありません" unless current_user.admin?
  end
end

