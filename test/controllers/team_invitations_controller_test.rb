require "test_helper"

class TeamInvitationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get team_invitations_new_url
    assert_response :success
  end
end
