class CreateTasks < ActiveRecord::Migration[8.0]
  def up
    execute <<-SQL
      CREATE TYPE task_status AS ENUM ('not_started', 'in_progress', 'completed', 'cancelled');
    SQL
    execute <<-SQL
      CREATE TYPE task_priority AS ENUM ('low', 'medium', 'high');
    SQL

    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description
      t.date :due_date
      t.datetime :started_at
      t.datetime :completed_at
      t.integer :how_long_it_took
      t.references :business, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.references :assigned_to, foreign_key: { to_table: :users }
      t.column :priority, :task_priority, null: false, default: "low"
      t.column :status, :task_status, null: false, default: "not_started"

      t.timestamps
    end
  end

  def down
    drop_table :tasks
    execute "DROP TYPE IF EXISTS task_status;"
    execute "DROP TYPE IF EXISTS task_priority;"
  end
end
