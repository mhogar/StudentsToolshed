json.array!(@project_stats) do |stats|
	json.extract! stats, :id, :name, :description, :num_stories, :num_tasks, :percent
	#json.url task_tracker_project_url(stats, format: :json)
end