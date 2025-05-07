class TeamJoinRequestsController < ApplicationController
  before_action :authenticate_user!

  def new
    @token = params[:token]
    if @token.blank?
      redirect_to root_path, alert: "不正な招待URLです"
    end

    # いちいちDBにカラムを作らない簡単にオブジェクトを作る方法
    @join_request = OpenStruct.new(message: "")
  end

  def create
  end

  def index
  end

  def update
  end
end
