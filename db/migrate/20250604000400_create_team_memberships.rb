class CreateTeamMemberships < ActiveRecord::Migration[8.0]
  def up
    execute <<-SQL
      CREATE TYPE team_membership_status AS ENUM ('active', 'inactive');
    SQL

    execute <<-SQL
      CREATE TYPE team_membership_role AS ENUM ('member', 'team_lead');
    SQL

    create_table :team_memberships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.column :role, :team_membership_role, default: 'member'
      t.column :status, :team_membership_status, default: 'active'

      t.timestamps
    end

    add_index :team_memberships, [ :user_id, :team_id ], unique: true, name: "index_team_memberships_on_user_team"
    add_index :team_memberships, :role
    add_index :team_memberships, :status
  end

  def down
    drop_table :team_memberships
    execute "DROP TYPE IF EXISTS team_membership_status;"
    execute "DROP TYPE IF EXISTS team_membership_role;"
  end
end
