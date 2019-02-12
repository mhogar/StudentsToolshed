class CreateTaskTrackerStories < ActiveRecord::Migration[5.2]
  def change
    create_table :task_tracker_stories do |t|
      t.references :project, index: true
      t.string :name

      t.timestamps
    end

    add_foreign_key :task_tracker_stories, :task_tracker_projects, column: :project_id
  end
end
