class TaskTracker::Task < ApplicationRecord
	self.table_name = "task_tracker_tasks"

	NAME_MIN_LENGTH = 5
	NAME_MAX_LENGTH = 100
	TIME_ESTIMATE_MIN_VALUE = 1
	TIME_ESTIMATE_MAX_VALUE = 40

	has_one :object_map, as: :object, class_name: "TaskTracker::ObjectMap"
	has_one :fractal_interface, through: :object_map, source: :task_tracker_interface

	belongs_to :story, class_name: "TaskTracker::Story"

	validates :story_id, presence: true
	validates :name, length: { minimum: NAME_MIN_LENGTH, maximum: NAME_MAX_LENGTH }
	validates :time_estimate, inclusion: { in: TIME_ESTIMATE_MIN_VALUE..TIME_ESTIMATE_MAX_VALUE }
end
