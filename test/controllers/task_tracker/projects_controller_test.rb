require 'test_helper'

class TaskTracker::ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project = task_tracker_projects(:one)
    @new_project = TaskTracker::Project.new(user_id: 1, name: "A new project", description: "This is the description")
  end

  test "get stats" do
    get "/task_tracker/project_stats/", as: :json

    assert_response :success

    project = task_tracker_projects(:one)
    stats_one = {
      'id' => project.id,
      'name' => project.name,
      'description' => project.description,
      'num_stories' => 2,
      'num_tasks' => 2,
      'percent' => 50
    }
    
    project = task_tracker_projects(:two)
    stats_two = {
      'id' => project.id,
      'name' => project.name,
      'description' => project.description,
      'num_stories' => 0,
      'num_tasks' => 0,
      'percent' => 0
    }

    response = JSON.parse(@response.body)
    assert_equal(response.count, 2)
    test_stats(stats_one, response[0])
    test_stats(stats_two, response[1])
  end

  test "show project" do
    get "/task_tracker/projects/#{@project.id}", as: :json

    assert_response :success
    response = JSON.parse(@response.body)

    test_model_fields(@project, response)
    assert_equal(response['stories'].count, 2)
  end

  test "create project" do
    assert_difference('TaskTracker::Project.count') do
      post "/task_tracker/projects/", params: { project: @new_project }, as: :json
    end

    assert_response 201
    test_model_fields(@new_project, JSON.parse(@response.body))
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

    def test_stats(expected, actual)
      ['id', 'name', 'description', 'num_stories', 'num_tasks', 'percent'].each { |field| assert_equal(expected[field], actual[field], "stats #{field} did not match") }
    end
end
