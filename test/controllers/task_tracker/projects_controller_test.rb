require 'test_helper'

class TaskTracker::ProjectsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @project = task_tracker_projects(:one)
    @new_project = TaskTracker::Project.new(name: "A new project", description: "This is the description")

    sign_in users(:alice)
  end

  test "get stats" do
    url = "/task_tracker/project_stats/"

    get url, as: :json
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

    test_no_user do
      get url, as: :json
    end

    #test different results with different user
    sign_in users(:bob)

    get url, as: :json
    assert_response :success
    assert_equal(JSON.parse(@response.body).count, 0)
  end

  test "show project" do
    url = "/task_tracker/projects/#{@project.id}"
    get url, as: :json

    assert_response :success
    response = JSON.parse(@response.body)

    test_model_fields(@project, response)
    assert_equal(response['stories'].count, 2)

    story = response['stories'][0]
    assert_not_nil(story['tasks'])
    assert_equal(story['tasks'].count, 2)

    story = response['stories'][1]
    assert_not_nil(story['tasks'])
    assert_empty(story['tasks'])

    test_no_user do
      get url, as: :json
    end

    test_wrong_user do
      get url, as: :json
    end
  end

  test "create project" do
    url = "/task_tracker/projects/"
    params = { project: @new_project }

    assert_difference('TaskTracker::Project.count', 1) do
      post url, params: params, as: :json
    end

    assert_response :created
    response = JSON.parse(@response.body)
    test_model_fields(@new_project, response)

    #test this user can access the new project
    show_url = "/task_tracker/projects/#{response['id']}"
    get show_url, as: :json
    assert_response :success

    #test accessing the new project with a different user is denied
    test_wrong_user do
      get show_url, as: :json
    end

    test_no_user do
      post url, params: params, as: :json
    end
  end

  test "update project" do
    url = "/task_tracker/projects/#{@project.id}"
    params = { project: @new_project }

    assert_difference('TaskTracker::Project.count', 0) do
      put url, params: params, as: :json
    end

    assert_response :ok
    test_model_fields(@new_project, JSON.parse(@response.body))

    test_no_user do
      put url, params: params, as: :json
    end

    test_wrong_user do
      put url, params: params, as: :json
    end
  end

  test "destroy project" do
    url = "/task_tracker/projects/#{@project.id}"

    assert_difference('TaskTracker::Project.count', -1) do
      assert_difference('TaskTracker::Story.count', -2) do
        assert_difference('TaskTracker::Task.count', -2) do
          delete "/task_tracker/projects/#{@project.id}", as: :json
        end
      end
    end

    assert_response :no_content
  end

  test "destroy project with wrong user" do
    url = "/task_tracker/projects/#{@project.id}"
    
    test_no_user do
      delete url, as: :json
    end

    test_wrong_user do
      delete url, as: :json
    end
  end

  private
    def test_model_fields(src_model, test_model)
      ['name', 'description'].each { |field| assert_equal(src_model[field], test_model[field]) }
    end

    def test_stats(expected, actual)
      ['id', 'name', 'description', 'num_stories', 'num_tasks', 'percent'].each { |field| assert_equal(expected[field], actual[field], "stats #{field} did not match") }
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
