json.extract! task, :id, :story_id, :name, :completed, :time_estimate, :created_at, :updated_at
json.url task_tracker_task_url(task, format: :json)