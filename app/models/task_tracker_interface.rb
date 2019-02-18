class TaskTrackerInterface < ApplicationRecord
	belongs_to :user

	has_many :object_maps, class_name: "TaskTracker::ObjectMap"
	has_many :projects, through: :object_maps, source: :object, source_type: "TaskTracker::Project"
	has_many :stories, through: :object_maps, source: :object, source_type: "TaskTracker::Story"
	has_many :tasks, through: :object_maps, source: :object, source_type: "TaskTracker::Task"
end
