require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @session = sessions(:one)
  end

  test "should get index" do
    get sessions_url
    assert_response :success
  end

  test "should get new" do
    get new_session_url
    assert_response :success
  end

  test "should create session" do
    assert_difference("Session.count") do
      post sessions_url, params: { session: { body_fat: @session.body_fat, body_weight: @session.body_weight, content: @session.content, datetime: @session.datetime, memo: @session.memo, part: @session.part, user_id: @session.user_id } }
    end

    assert_redirected_to session_url(Session.last)
  end

  test "should show session" do
    get session_url(@session)
    assert_response :success
  end

  test "should get edit" do
    get edit_session_url(@session)
    assert_response :success
  end

  test "should update session" do
    patch session_url(@session), params: { session: { body_fat: @session.body_fat, body_weight: @session.body_weight, content: @session.content, datetime: @session.datetime, memo: @session.memo, part: @session.part, user_id: @session.user_id } }
    assert_redirected_to session_url(@session)
  end

  test "should destroy session" do
    assert_difference("Session.count", -1) do
      delete session_url(@session)
    end

    assert_redirected_to sessions_url
  end
end
