# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_06_20_194258) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "assignment_priority", ["low", "medium", "high"]
  create_enum "assignment_recurrent_pattern", ["daily", "weekly", "monthly", "quarterly", "semiannually", "annually"]
  create_enum "assignment_status", ["scheduled", "in_progress", "completed", "cancelled"]
  create_enum "business_status", ["active", "inactive"]
  create_enum "task_location", ["window", "floor", "room", "other"]
  create_enum "team_membership_role", ["member", "team_lead"]
  create_enum "team_membership_status", ["active", "inactive"]
  create_enum "team_status", ["active", "inactive"]
  create_enum "user_role", ["admin", "manager", "cleaner", "user"]

  create_table "businesses", force: :cascade do |t|
    t.string "name", null: false
    t.string "address", null: false
    t.string "phone"
    t.string "email"
    t.text "notes"
    t.enum "status", default: "active", enum_type: "business_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_businesses_on_name"
    t.index ["status"], name: "index_businesses_on_status"
  end

  create_table "cleaning_assignment_tasks", force: :cascade do |t|
    t.bigint "cleaning_assignment_id", null: false
    t.bigint "task_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cleaning_assignment_id", "task_id"], name: "index_cleaning_assignment_tasks_on_assignment_and_task", unique: true
    t.index ["cleaning_assignment_id"], name: "index_cleaning_assignment_tasks_on_cleaning_assignment_id"
    t.index ["task_id"], name: "index_cleaning_assignment_tasks_on_task_id"
  end

  create_table "cleaning_assignments", force: :cascade do |t|
    t.text "notes"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "scheduled_date", null: false
    t.integer "total_estimated_duration_minutes"
    t.integer "actual_duration_minutes"
    t.enum "status", default: "scheduled", null: false, enum_type: "assignment_status"
    t.enum "priority", default: "low", enum_type: "assignment_priority"
    t.jsonb "metadata", default: {"number_of_floors"=>nil, "number_of_windows"=>nil, "special_instructions"=>nil}
    t.bigint "team_id", null: false
    t.bigint "business_id", null: false
    t.bigint "assigned_to_id"
    t.bigint "recurring_assignment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assigned_to_id"], name: "index_cleaning_assignments_on_assigned_to_id"
    t.index ["business_id"], name: "index_cleaning_assignments_on_business_id"
    t.index ["recurring_assignment_id"], name: "index_cleaning_assignments_on_recurring_assignment_id"
    t.index ["scheduled_date"], name: "index_cleaning_assignments_on_scheduled_date"
    t.index ["status"], name: "index_cleaning_assignments_on_status"
    t.index ["team_id"], name: "index_cleaning_assignments_on_team_id"
  end

  create_table "recurring_assignments", force: :cascade do |t|
    t.date "recurrence_end_date"
    t.boolean "is_active", default: true
    t.boolean "is_recurring", default: false
    t.enum "recurrence_pattern", enum_type: "assignment_recurrent_pattern"
    t.integer "recurrence_interval", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.integer "quantity"
    t.enum "location", default: "window", enum_type: "task_location"
    t.integer "estimated_duration"
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location"], name: "index_tasks_on_location"
    t.index ["title"], name: "index_tasks_on_title"
  end

  create_table "team_memberships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "team_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.enum "role", default: "member", enum_type: "team_membership_role"
    t.enum "status", default: "active", enum_type: "team_membership_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role"], name: "index_team_memberships_on_role"
    t.index ["status"], name: "index_team_memberships_on_status"
    t.index ["team_id"], name: "index_team_memberships_on_team_id"
    t.index ["user_id", "team_id"], name: "index_team_memberships_on_user_team", unique: true
    t.index ["user_id"], name: "index_team_memberships_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.enum "status", default: "active", enum_type: "team_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_teams_on_name"
    t.index ["status"], name: "index_teams_on_status"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "phone", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.enum "role", default: "user", enum_type: "user_role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "cleaning_assignment_tasks", "cleaning_assignments"
  add_foreign_key "cleaning_assignment_tasks", "tasks"
  add_foreign_key "cleaning_assignments", "businesses"
  add_foreign_key "cleaning_assignments", "recurring_assignments"
  add_foreign_key "cleaning_assignments", "teams"
  add_foreign_key "cleaning_assignments", "users", column: "assigned_to_id"
  add_foreign_key "sessions", "users"
  add_foreign_key "team_memberships", "teams"
  add_foreign_key "team_memberships", "users"
end
