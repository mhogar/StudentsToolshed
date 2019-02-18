json.extract! project, :id, :name, :description, :created_at, :updated_at
json.stories do
	json.array! project.stories, partial: 'task_tracker/stories/story', as: :story
end
json.url task_tracker_project_url(project, format: :json)