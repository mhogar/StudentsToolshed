class CreateTaskTrackerProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :task_tracker_projects do |t|
      t.belongs_to :user, index: true
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
