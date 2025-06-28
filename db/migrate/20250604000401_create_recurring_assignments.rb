class CreateRecurringAssignments < ActiveRecord::Migration[8.0]
  def up
    execute <<-SQL
      CREATE TYPE assignment_recurrent_pattern AS ENUM ('daily', 'weekly', 'monthly', 'quarterly', 'semiannually', 'annually');
    SQL

    create_table :recurring_assignments do |t|
      t.date :recurrence_end_date
      t.boolean :is_active, default: true
      t.boolean :is_recurring, default: false
      t.column :recurrence_pattern, :assignment_recurrent_pattern
      t.integer :recurrence_interval, default: 1 # Interval for the recurrence pattern (e.g., every 1 week, every 2 months, 1 quarterly, once annually, every 1 six monetc.)

      t.timestamps
    end
  end

  def down
    drop_table :recurring_assignments
    execute "DROP TYPE IF EXISTS assignment_recurrent_pattern;"
  end
end
