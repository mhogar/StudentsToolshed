json.array!(@project_stats) do |stats|
	json.extract! stats, :id, :name, :description, :numStories, :numTasks, :percent
	#json.url task_tracker_project_url(stats, format: :json)
end