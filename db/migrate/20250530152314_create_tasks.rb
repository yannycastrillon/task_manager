class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.string :priority
      t.string :status
      t.date :due_date

      t.timestamps
    end
  end
end
