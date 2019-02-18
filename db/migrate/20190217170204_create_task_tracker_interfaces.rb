class CreateTaskTrackerInterfaces < ActiveRecord::Migration[5.2]
  def change
    create_table :task_tracker_interfaces do |t|
    	t.references :user, index: true
    end
  end
end
