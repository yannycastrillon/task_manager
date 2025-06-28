class CreateCleaningAssignmentTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :cleaning_assignment_tasks do |t|
      t.references :cleaning_assignment, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true

      t.timestamps
    end
    add_index :cleaning_assignment_tasks, [ :cleaning_assignment_id, :task_id ], unique: true, name: 'index_cleaning_assignment_tasks_on_assignment_and_task'
  end
end
