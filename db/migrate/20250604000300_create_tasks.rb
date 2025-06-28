class CreateTasks < ActiveRecord::Migration[8.0]
  def up
    execute <<-SQL
      CREATE TYPE task_location AS ENUM ('window', 'floor', 'room', 'other');
    SQL

    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description
      t.integer :quantity # Number of items (windows, floors, rooms, etc.)
      t.column :location, :task_location, default: "window" # Item location (e.g., "window", "floor", "room")
      t.integer :estimated_duration # in minutes
      t.jsonb :metadata, default: {} # JSONB for additional task metadata

      t.timestamps
    end

    add_index :tasks, :title
    add_index :tasks, :location
  end

  def down
    execute "DROP TYPE IF EXISTS task_location;"

    drop_table :tasks
  end
end
