class TaskTrackerTask < ApplicationRecord
	belongs_to :story, class_name: "TaskTrackerStory"
end
