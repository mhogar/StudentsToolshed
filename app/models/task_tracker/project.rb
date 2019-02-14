class TaskTracker::Project < ApplicationRecord
	self.table_name = "task_tracker_projects"

	NAME_MIN_LENGTH = 1
	NAME_MAX_LENGTH = 20
	DESC_MIN_LENGTH = 10
	DESC_MAX_LENGTH = 100

	belongs_to :user
	has_many :stories, class_name: "TaskTracker::Story", foreign_key: "project_id"

	validates :user_id, presence: true
	validates :name, length: { minimum: NAME_MIN_LENGTH, maximum: NAME_MAX_LENGTH }
	validates :description, allow_blank: true, length: { minimum: DESC_MIN_LENGTH, maximum: DESC_MAX_LENGTH }
end
