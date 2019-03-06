class AddTimeEstimateToTaskTrackerTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :task_tracker_tasks, :time_estimate, :integer, unsigned: true, limit: 1, null: false, default: 1
  end
end
