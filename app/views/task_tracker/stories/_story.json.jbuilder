json.extract! story, :id, :project_id, :name, :created_at, :updated_at
json.tasks do
	json.array! story.tasks, partial: 'task_tracker/tasks/task', as: :task
end
json.url task_tracker_story_url(story, format: :json)
