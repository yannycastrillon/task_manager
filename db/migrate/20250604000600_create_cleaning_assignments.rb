class CreateCleaningAssignments < ActiveRecord::Migration[8.0]
  def up
    execute <<-SQL
      CREATE TYPE assignment_status AS ENUM ('scheduled', 'in_progress', 'completed', 'cancelled');
    SQL

    execute <<-SQL
      CREATE TYPE assignment_priority AS ENUM ('low', 'medium', 'high');
    SQL

    create_table :cleaning_assignments do |t|
      t.text :notes
      t.datetime :started_at
      t.datetime :completed_at
      t.datetime :scheduled_date, null: false
      t.integer :total_estimated_duration_minutes # Sum of all task durations in the assignment + driving time + setup time, etc.
      t.integer :actual_duration_minutes # Actual time spent on the assignment
      t.column :status, :assignment_status, null: false, default: 'scheduled'
      t.column :priority, :assignment_priority, default: 'low'
      t.jsonb :metadata, default: {
        special_instructions: nil,
        number_of_windows: nil,
        number_of_floors: nil
      }

      t.references :team, null: false, foreign_key: true
      t.references :business, null: false, foreign_key: true
      t.references :assigned_to, foreign_key: { to_table: :users }, null: true
      t.references :recurring_assignment, foreign_key: true, null: true

      t.timestamps
    end

    add_index :cleaning_assignments, :scheduled_date
    add_index :cleaning_assignments, :status
  end

  def down
    drop_table :cleaning_assignments
    execute "DROP TYPE IF EXISTS assignment_status;"
    execute "DROP TYPE IF EXISTS assignment_priority;"
  end
end
