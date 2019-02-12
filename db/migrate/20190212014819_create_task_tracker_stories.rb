class CreateTaskTrackerStories < ActiveRecord::Migration[5.2]
  def change
    create_table :task_tracker_stories do |t|
      t.belongs_to :task_tracker_project, index: true
      t.string :name

      t.timestamps
    end
  end
end
