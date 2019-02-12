require 'test_helper'

class TaskTrackerTaskTest < ActiveSupport::TestCase
	setup do
		@task = TaskTrackerTask.new(story_id: 1, name: "A task name")
	end

	test "task is valid" do
		assert @task.valid?
	end

	test "task without story id is invalid" do
		@task.story_id = nil
		assert_not @task.valid?
	end

	test "task without name is invalid" do
		@task.name = nil
		assert_not @task.valid?
	end

	test "task with name too short is invalid" do
		#min length is valid
		@task.name = "a" * (TaskTrackerTask::NAME_MIN_LENGTH)
		assert @task.valid?

		#one less than min is not valid
		@task.name = "a" * (TaskTrackerTask::NAME_MIN_LENGTH - 1)
		assert_not @task.valid?
	end

	test "task with name too long is invalid" do
		#max length is valid
		@task.name = "a" * (TaskTrackerTask::NAME_MAX_LENGTH )
		assert @task.valid?

		#one more than max in not valid
		@task.name = "a" * (TaskTrackerTask::NAME_MAX_LENGTH + 1)
		assert_not @task.valid?
	end
end
