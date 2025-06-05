class CreateUsers < ActiveRecord::Migration[8.0]
  def up
    execute <<-SQL
      CREATE TYPE user_role AS ENUM ('admin', 'manager', 'cleaner', 'user');
    SQL

    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :phone, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.column :role, :user_role, default: "user"

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :role
  end

  def down
    drop_table :users
    execute "DROP TYPE IF EXISTS user_role;"
  end
end
