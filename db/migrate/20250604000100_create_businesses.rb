class CreateBusinesses < ActiveRecord::Migration[8.0]
  def up
    execute <<-SQL
      CREATE TYPE business_status AS ENUM ('active', 'inactive');
    SQL

    create_table :businesses do |t|
      t.string :name, null: false
      t.string :address, null: false
      t.string :phone
      t.string :email
      t.text :notes
      t.column :status, :business_status, default: "active"

      t.timestamps
    end

    add_index :businesses, :name
    add_index :businesses, :status
  end

  def down
    drop_table :businesses
    execute "DROP TYPE IF EXISTS business_status;"
  end
end
