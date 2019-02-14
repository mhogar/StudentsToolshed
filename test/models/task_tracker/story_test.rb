require 'test_helper'

class TaskTrackerStoryTest < ActiveSupport::TestCase
  setup do
		@story = task_tracker_stories(:one)
	end

	test "story is valid" do
		assert @story.valid?
	end

	test "story without project id is invalid" do
		@story.project_id = nil
		assert_not @story.valid?
	end

	test "story without name is invalid" do
		@story.name = nil
		assert_not @story.valid?
	end

	test "story with name too short is invalid" do
		#min length is valid
		@story.name = "a" * (TaskTracker::Story::NAME_MIN_LENGTH)
		assert @story.valid?

		#one less than min is not valid
		@story.name = "a" * (TaskTracker::Story::NAME_MIN_LENGTH - 1)
		assert_not @story.valid?
	end

	test "story with name too long is invalid" do
		#max length is valid
		@story.name = "a" * (TaskTracker::Story::NAME_MAX_LENGTH )
		assert @story.valid?

		#one more than max in not valid
		@story.name = "a" * (TaskTracker::Story::NAME_MAX_LENGTH + 1)
		assert_not @story.valid?
	end
end
