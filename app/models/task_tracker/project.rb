class TaskTracker::Project < ApplicationRecord
	self.table_name = "task_tracker_projects"

	belongs_to :user
	has_many :stories, class_name: "TaskTracker::Story", foreign_key: "project_id"
end
