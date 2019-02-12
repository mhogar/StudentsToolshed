class TaskTrackerTask < ApplicationRecord
	NAME_MIN_LENGTH = 5
	NAME_MAX_LENGTH = 100

	belongs_to :story, class_name: "TaskTrackerStory"

	validates :story_id, presence: true
	validates :name, length: { minimum: NAME_MIN_LENGTH, maximum: NAME_MAX_LENGTH }
end
