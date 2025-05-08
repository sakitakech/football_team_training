class TeamJoinRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!

  def new
    @token = params[:token]

    unless @token.present?
      redirect_to root_path, alert: "無効な招待リンクです"
      return
    end

    # 仮の参加リクエストオブジェクト（Structで作る）
    TeamJoinRequest = Struct.new(:message, keyword_init: true)
    # 名前付き引数にでき可読性が高まる
    @join_request = TeamJoinRequest.new
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
  end

  def update
  end
end

