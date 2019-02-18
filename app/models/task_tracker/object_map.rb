class TaskTracker::ObjectMap < ApplicationRecord
	self.table_name = "task_tracker_object_maps"

	belongs_to :object, polymorphic: true
	belongs_to :task_tracker_interface
end
