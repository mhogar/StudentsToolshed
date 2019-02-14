require 'test_helper'

class TaskTracker::ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project = task_tracker_projects(:one)
    @new_project = TaskTracker::Project.new(user_id: 1, name: "A new project", description: "This is the description")
  end

  test "create project" do
    assert_difference('TaskTracker::Project.count') do
      post "/task_tracker/projects/", params: { project: @new_project }, as: :json
    end

    assert_response 201
    test_model_fields(@new_project, JSON.parse(@response.body))
  end

  test "show project" do
    get "/task_tracker/projects/#{@project.id}", as: :json
    assert_response :success
  end

  test "update project" do
    assert_difference('TaskTracker::Project.count', 0) do
      put "/task_tracker/projects/#{@project.id}", params: { project: @new_project }, as: :json
    end

    assert_response 200
    test_model_fields(@new_project, JSON.parse(@response.body))
  end

  test "destroy project" do
    assert_difference('TaskTracker::Project.count', -1) do
      delete "/task_tracker/projects/#{@project.id}", as: :json
    end

    assert_response 204
  end

  private
    def test_model_fields(src_model, test_model)
      ['user_id', 'name', 'description'].each { |field| assert_equal(src_model[field], test_model[field]) }
    end
end
