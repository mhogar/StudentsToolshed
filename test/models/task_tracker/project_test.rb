require 'test_helper'

class TaskTrackerProjectTest < ActiveSupport::TestCase
	setup do
		@project = task_tracker_projects(:one)
	end

	test "project is valid" do
		assert @project.valid?
	end

	test "project without name is invalid" do
		@project.name = nil
		assert_not @project.valid?
	end

	test "project with name too short is invalid" do
		#min length is valid
		@project.name = "a" * (TaskTracker::Project::NAME_MIN_LENGTH)
		assert @project.valid?

		#one less than min is not valid
		@project.name = "a" * (TaskTracker::Project::NAME_MIN_LENGTH - 1)
		assert_not @project.valid?
	end

	test "project with name too long is invalid" do
		#max length is valid
		@project.name = "a" * (TaskTracker::Project::NAME_MAX_LENGTH )
		assert @project.valid?

		#one more than max in not valid
		@project.name = "a" * (TaskTracker::Project::NAME_MAX_LENGTH + 1)
		assert_not @project.valid?
	end

	test "project without description is valid" do
		@project.description = nil
		assert @project.valid?
	end

	test "project with description too short is invalid" do
		#min length is valid
		@project.description = "a" * (TaskTracker::Project::DESC_MIN_LENGTH)
		assert @project.valid?

		#one less than min is not valid
		@project.description = "a" * (TaskTracker::Project::DESC_MIN_LENGTH - 1)
		assert_not @project.valid?
	end

	test "project with description too long is invalid" do
		#max length is valid
		@project.description = "a" * (TaskTracker::Project::DESC_MAX_LENGTH )
		assert @project.valid?

		#one more than max in not valid
		@project.description = "a" * (TaskTracker::Project::DESC_MAX_LENGTH + 1)
		assert_not @project.valid?
	end
end
