require "test_helper"

class TeamJoinRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get team_join_requests_new_url
    assert_response :success
  end

  test "should get create" do
    get team_join_requests_create_url
    assert_response :success
  end

  test "should get index" do
    get team_join_requests_index_url
    assert_response :success
  end

  test "should get update" do
    get team_join_requests_update_url
    assert_response :success
  end
end
