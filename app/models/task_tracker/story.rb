class TaskTracker::Story < ApplicationRecord
	self.table_name = "task_tracker_stories"

	NAME_MIN_LENGTH = 5
	NAME_MAX_LENGTH = 100

	belongs_to :project, class_name: "TaskTracker::Project"
	has_many :tasks, class_name: "TaskTracker::Task", foreign_key: "story_id", dependent: :delete_all

	validates :project_id, presence: true
	validates :name, length: { minimum: NAME_MIN_LENGTH, maximum: NAME_MAX_LENGTH }
end
