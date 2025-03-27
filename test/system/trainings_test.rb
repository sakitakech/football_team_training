require "application_system_test_case"

class TrainingsTest < ApplicationSystemTestCase
  setup do
    @training = trainings(:one)
  end

  test "visiting the index" do
    visit trainings_url
    assert_selector "h1", text: "Trainings"
  end

  test "should create training" do
    visit trainings_url
    click_on "New training"

    fill_in "Body fat", with: @training.body_fat
    fill_in "Body weight", with: @training.body_weight
    fill_in "Content", with: @training.content
    fill_in "Datetime", with: @training.datetime
    fill_in "Memo", with: @training.memo
    fill_in "Part", with: @training.part
    fill_in "User", with: @training.user_id
    click_on "Create Training"

    assert_text "Training was successfully created"
    click_on "Back"
  end

  test "should update Training" do
    visit training_url(@training)
    click_on "Edit this training", match: :first

    fill_in "Body fat", with: @training.body_fat
    fill_in "Body weight", with: @training.body_weight
    fill_in "Content", with: @training.content
    fill_in "Datetime", with: @training.datetime.to_s
    fill_in "Memo", with: @training.memo
    fill_in "Part", with: @training.part
    fill_in "User", with: @training.user_id
    click_on "Update Training"

    assert_text "Training was successfully updated"
    click_on "Back"
  end

  test "should destroy Training" do
    visit training_url(@training)
    click_on "Destroy this training", match: :first

    assert_text "Training was successfully destroyed"
  end
end
