require 'test_helper'

class TaskTracker::StoriesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @story = task_tracker_stories(:one)
    @new_story = TaskTracker::Story.new(project_id: 1, name: "A new story")

    sign_in users(:alice)
  end

  test "show story" do
    url = "/task_tracker/stories/#{@story.id}"

    get url, as: :json

    assert_response :success
    response = JSON.parse(@response.body)

    test_model_fields(@story, response)
    assert_equal(response['tasks'].count, 2)

    test_no_user do
      get url, as: :json
    end

    test_wrong_user do
      get url, as: :json
    end
  end

  test "create story" do
    url = "/task_tracker/stories/"
    params = { story: @new_story }

    assert_difference('TaskTracker::Story.count', 1) do
      post url, params: params, as: :json
    end

    assert_response :created
    test_model_fields(@new_story, JSON.parse(@response.body))

    test_no_user do
      post url, params: params, as: :json
    end
  end

  test "update story" do
    url = "/task_tracker/stories/#{@story.id}"
    params = { story: @new_story }

    assert_difference('TaskTracker::Story.count', 0) do
      put url, params: params, as: :json
    end

    assert_response :ok
    test_model_fields(@new_story, JSON.parse(@response.body))

    test_no_user do
      put url, params: params, as: :json
    end

    test_wrong_user do
      put url, params: params, as: :json
    end
  end

  test "destroy story" do
    assert_difference('TaskTracker::Story.count', -1) do
      assert_difference('TaskTracker::Task.count', -2) do
        delete "/task_tracker/stories/#{@story.id}", as: :json
      end
    end

    assert_response :no_content
  end

  test "destroy story with wrong user" do
    url = "/task_tracker/stories/#{@story.id}"
    
    test_no_user do
      delete url, as: :json
    end

    test_wrong_user do
      delete url, as: :json
    end
  end

  private
    def test_model_fields(src_model, test_model)
      ['project_id', 'name'].each { |field| assert_equal(src_model[field], test_model[field]) }
    end

    def test_no_user
      sign_out :user
      yield
      assert_response :unauthorized
    end

    def test_wrong_user
      sign_in users(:bob)
      yield
      assert_response :unauthorized
    end
end
