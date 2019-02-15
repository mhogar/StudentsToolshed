require 'test_helper'

class TaskTracker::StoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @story = task_tracker_stories(:one)
    @new_story = TaskTracker::Story.new(project_id: 1, name: "A new story")
  end

  test "show story" do
    get "/task_tracker/stories/#{@story.id}", as: :json

    assert_response :success
    test_model_fields(@story, JSON.parse(@response.body))
  end

  test "get by project_id" do
    get "/task_tracker/stories/?project_id=1", as: :json

    assert_response :success
    response = JSON.parse(@response.body)

    assert_equal(response.count, 2)
    test_model_fields(task_tracker_stories(:one), response[0])
    test_model_fields(task_tracker_stories(:two), response[1])
  end

  test "create story" do
    assert_difference('TaskTracker::Story.count', 1) do
      post "/task_tracker/stories/", params: { story: @new_story }, as: :json
    end

    assert_response 201
    test_model_fields(@new_story, JSON.parse(@response.body))
  end

  test "update story" do
    assert_difference('TaskTracker::Story.count', 0) do
      put "/task_tracker/stories/#{@story.id}", params: { story: @new_story }, as: :json
    end

    assert_response 200
    test_model_fields(@new_story, JSON.parse(@response.body))
  end

  test "destroy story" do
    assert_difference('TaskTracker::Story.count', -1) do
      delete "/task_tracker/stories/#{@story.id}", as: :json
    end

    assert_response 204
  end

  private
    def test_model_fields(src_model, test_model)
      ['project_id', 'name'].each { |field| assert_equal(src_model[field], test_model[field]) }
    end
end
