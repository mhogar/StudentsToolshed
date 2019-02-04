require 'test_helper'

class TaskTrackersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @task_tracker = task_trackers(:one)
  end

  test "should get index" do
    get task_trackers_url, as: :json
    assert_response :success
  end

  test "should create task_tracker" do
    assert_difference('TaskTracker.count') do
      post task_trackers_url, params: { task_tracker: { completed: @task_tracker.completed, name: @task_tracker.name, story_id: @task_tracker.story_id } }, as: :json
    end

    assert_response 201
  end

  test "should show task_tracker" do
    get task_tracker_url(@task_tracker), as: :json
    assert_response :success
  end

  test "should update task_tracker" do
    patch task_tracker_url(@task_tracker), params: { task_tracker: { completed: @task_tracker.completed, name: @task_tracker.name, story_id: @task_tracker.story_id } }, as: :json
    assert_response 200
  end

  test "should destroy task_tracker" do
    assert_difference('TaskTracker.count', -1) do
      delete task_tracker_url(@task_tracker), as: :json
    end

    assert_response 204
  end
end
