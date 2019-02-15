class TaskTracker::Task < ApplicationRecord
	self.table_name = "task_tracker_tasks"

	NAME_MIN_LENGTH = 5
	NAME_MAX_LENGTH = 100

	belongs_to :story, class_name: "TaskTracker::Story"

	validates :story_id, presence: true
	validates :name, length: { minimum: NAME_MIN_LENGTH, maximum: NAME_MAX_LENGTH }
end