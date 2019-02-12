class CreateTaskTrackerProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :task_tracker_projects do |t|
      t.references :user, index: true, foreign_key: true
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
