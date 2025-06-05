class CreateCleaningAssignments < ActiveRecord::Migration[8.0]
  def up
    execute <<-SQL
      CREATE TYPE assignment_status AS ENUM ('scheduled', 'in_progress', 'completed', 'cancelled');
    SQL

    execute <<-SQL
      CREATE TYPE assignment_recurrent_pattern AS ENUM ('daily', 'weekly', 'bi_weekly', 'tri_weekly', 'monthly', 'quarterly', 'semi_annually', 'annually');
    SQL

    create_table :cleaning_assignments do |t|
      t.datetime :scheduled_date, null: false
      t.datetime :started_at
      t.datetime :completed_at
      t.integer :estimated_duration_minutes
      t.integer :actual_duration_minutes
      t.text :notes
      t.text :special_instructions
      t.integer :number_of_windows
      t.integer :number_of_floors
      t.boolean :requires_special_equipment, default: false
      t.boolean :requires_insurance_verification, default: false
      t.column :status, :assignment_status, null: false, default: 'scheduled'
      t.decimal :price, precision: 10, scale: 2
      t.string :payment_status
      t.datetime :last_cleaned_at
      t.integer :cleaning_frequency_days
      t.boolean :is_recurring, default: false
      t.column :recurrence_pattern, :assignment_recurrent_pattern
      t.date :recurrence_end_date

      t.references :team, null: false, foreign_key: true
      t.references :business, null: false, foreign_key: true

      t.timestamps
    end

    add_index :cleaning_assignments, :scheduled_date
    add_index :cleaning_assignments, :status
    add_index :cleaning_assignments, :payment_status
  end

  def down
    drop_table :cleaning_assignments
    execute "DROP TYPE IF EXISTS assignment_status;"
    execute "DROP TYPE IF EXISTS assignment_recurrent_pattern;"
  end
end
