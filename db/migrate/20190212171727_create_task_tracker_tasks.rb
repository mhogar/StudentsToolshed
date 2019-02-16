class CreateTaskTrackerTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :task_tracker_tasks do |t|
      t.references :story, index: true
      t.references :project, index: true
      t.string :name
      t.boolean :completed, default: false

      t.timestamps
    end

    add_foreign_key :task_tracker_tasks, :task_tracker_stories, column: :story_id
    add_foreign_key :task_tracker_tasks, :task_tracker_projects, column: :project_id
  end
end
