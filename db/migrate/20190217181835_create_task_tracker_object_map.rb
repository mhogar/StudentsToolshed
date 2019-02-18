class CreateTaskTrackerObjectMap < ActiveRecord::Migration[5.2]
  def change
    create_table :task_tracker_object_maps do |t|
      t.references :task_tracker_interface, index: true
      t.references :object, polymorphic: true, index: { name: 'index_task_tracker_object_map_on_obj_type_and_obj_id' }
    end
  end
end
