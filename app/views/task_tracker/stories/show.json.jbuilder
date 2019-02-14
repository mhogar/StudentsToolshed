json.extract! @story, :id, :project_id, :name, :created_at, :updated_at
json.url task_tracker_story_url(@story, format: :json)
