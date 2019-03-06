require 'test_helper'

class TaskTracker::TasksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

	setup do
    @task = task_tracker_tasks(:one)
    @new_task = TaskTracker::Task.new(story_id: 1, name: "A new task", completed: true, time_estimate: 4)

    sign_in users(:alice)
  end

  test "show task" do
    url = "/task_tracker/tasks/#{@task.id}"
    get url, as: :json

    assert_response :success
    test_model_fields(@task, JSON.parse(@response.body))

    test_no_user do
      get url, as: :json
    end

    test_wrong_user do
      get url, as: :json
    end
  end

  test "create task" do
    url = "/task_tracker/tasks/"
    params = { task: @new_task }

    assert_difference('TaskTracker::Task.count', 1) do
      post url, params: params, as: :json
    end

    assert_response :created
    response = JSON.parse(@response.body)
    test_model_fields(@new_task, response)

    #test this user can access the new task
    show_url = "/task_tracker/tasks/#{response['id']}"
    get show_url, as: :json
    assert_response :success

    #test accessing the new task with a different user is denied
    test_wrong_user do
      get show_url, as: :json
    end

    test_no_user do
      post url, params: params, as: :json
    end
  end

  test "update task" do
    url = "/task_tracker/tasks/#{@task.id}"
    params = { task: @new_task }

  	assert_difference('TaskTracker::Task.count', 0) do
    	put url, params: params, as: :json
    end

    assert_response :ok
    test_model_fields(@new_task, JSON.parse(@response.body))

    test_no_user do
      put url, params: params, as: :json
    end

    test_wrong_user do
      put url, params: params, as: :json
    end
  end

  test "destroy task" do
    assert_difference('TaskTracker::Task.count', -1) do
      delete "/task_tracker/tasks/#{@task.id}", as: :json
    end

    assert_response :no_content

    #test parent story's updated_at was changed
    story = task_tracker_stories(:one)
    get "/task_tracker/stories/#{story.id}", as: :json
    assert_not_nil(JSON.parse(@response.body)['updated_at'])
    assert_not_equal(story.updated_at, JSON.parse(@response.body)['updated_at'])
  end

  test "destroy task with wrong user" do
    url = "/task_tracker/tasks/#{@task.id}"
    
    test_no_user do
      delete url, as: :json
    end

    test_wrong_user do
      delete url, as: :json
    end
  end

  private
  	def test_model_fields(src_model, test_model)
  		['story_id', 'name', 'completed', 'time_estimate'].each { |field| assert_equal(src_model[field], test_model[field]) }
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
