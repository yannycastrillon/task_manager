class CreateTeams < ActiveRecord::Migration[8.0]
  def up
    execute <<-SQL
      CREATE TYPE team_status AS ENUM ('active', 'inactive');
    SQL

    create_table :teams do |t|
      t.string :name, null: false
      t.text :description
      t.column :status, :team_status, default: 'active'

      t.timestamps
    end

    add_index :teams, :name
    add_index :teams, :status
  end

  def down
    drop_table :teams
    execute "DROP TYPE IF EXISTS team_status;"
  end
end
