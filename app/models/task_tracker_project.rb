class TaskTrackerProject < ApplicationRecord
	belongs_to :user
	has_many :stories, class_name: "TaskTrackerStory", foreign_key: "project_id"
end
