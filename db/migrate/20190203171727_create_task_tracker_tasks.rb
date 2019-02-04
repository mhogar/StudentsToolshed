class CreateTaskTrackerTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :task_tracker_tasks do |t|
      t.string :name
      t.boolean :completed, default: false

      t.timestamps
    end
  end
end
