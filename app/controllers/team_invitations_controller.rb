class TeamInvitationsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_team!

  def new
    @token = SecureRandom.hex(10)
    @invite = InviteToken.create!(
      token: @token,
      team: current_user.team,
      expires_at: 12.hours.from_now
    )
    @invite_url = new_team_join_request_url(token: @token)
  end

  private

  def require_team!
    redirect_to root_path, alert: "チームに所属していません" unless current_user.team
  end
end
