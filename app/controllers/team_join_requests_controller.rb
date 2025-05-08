class TeamJoinRequestsController < ApplicationController
  before_action :authenticate_user!

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
  end

  def index
  end

  def update
  end
end

