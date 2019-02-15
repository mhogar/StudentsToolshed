json.extract! project, :id, :user_id, :name, :description, :created_at, :updated_at
json.stories project.stories
json.url task_tracker_project_url(project, format: :json)