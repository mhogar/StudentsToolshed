require 'test_helper'

class TaskTracker::TasksControllerTest < ActionDispatch::IntegrationTest
	setup do
    @task = task_tracker_tasks(:one)
    @new_task = TaskTracker::Task.new(story_id: 1, name: "A new task", completed: true)
  end

  test "test create task" do
    assert_difference('TaskTracker::Task.count', 1) do
      post "/task_tracker/tasks/", params: { task: @new_task }, as: :json
    end

    assert_response 201
    test_model_fields(@new_task, JSON.parse(@response.body))
  end

  test "test show task" do
    get "/task_tracker/tasks/#{@task.id}", as: :json
    assert_response :success
  end

  test "test update task" do
  	assert_difference('TaskTracker::Task.count', 0) do
    	put "/task_tracker/tasks/#{@task.id}", params: { task: @new_task }, as: :json
    end

    assert_response 200
    test_model_fields(@new_task, JSON.parse(@response.body))
  end

  test "test destroy task" do
    assert_difference('TaskTracker::Task.count', -1) do
      delete "/task_tracker/tasks/#{@task.id}", as: :json
    end

    assert_response 204
  end

  private
  	def test_model_fields(src_model, test_model)
  		['name', 'completed'].each { |field| assert_equal(src_model[field], test_model[field]) }
  	end
end
