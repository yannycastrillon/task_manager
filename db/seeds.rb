# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'

Rails.logger.info "Seeding started..."

# === USERS ===
users = []
Rails.logger.info "Creating default users..." do
  admin = User.find_or_initialize_by(email: ENV["DEFAULT_ADMIN_EMAIL"]) do |user|
    user.password = ENV["DEFAULT_ADMIN_PASSWORD"]
    user.password_confirmation = ENV["DEFAULT_ADMIN_PASSWORD"]
    user.first_name = "Yanny"
    user.last_name = "Castrillon"
    user.phone = Faker::PhoneNumber.phone_number
    user.role = "admin"
  end

  if admin.new_record?
    admin.save!
    Rails.logger.info "Admin user created: #{admin.email}"
  else
    Rails.logger.info "Admin user already exists: #{admin.email}"
  end

  user = User.find_or_initialize_by(email: ENV["DEFAULT_USER_EMAIL"]) do |user|
    user.password = ENV["DEFAULT_USER_PASSWORD"]
    user.password_confirmation = ENV["DEFAULT_USER_PASSWORD"]
    user.first_name = "Jesus"
    user.last_name = "Viveros"
    user.phone = Faker::PhoneNumber.phone_number
    user.role = "user"
  end
  if user.new_record?
    user.save!
    Rails.logger.info "Created user created: #{user.email}"
  else
    Rails.logger.info "Created user already exists: #{user.email}"
  end

  # Create additional test users for role testing
  manager = User.find_or_initialize_by(email: "manager@test.com") do |user|
    user.password = "password123"
    user.password_confirmation = "password123"
    user.first_name = "Manager"
    user.last_name = "Test"
    user.phone = Faker::PhoneNumber.phone_number
    user.role = "manager"
  end
  if manager.new_record?
    manager.save!
    Rails.logger.info "Manager user created: #{manager.email}"
  else
    Rails.logger.info "Manager user already exists: #{manager.email}"
  end

  cleaner = User.find_or_initialize_by(email: "cleaner@test.com") do |user|
    user.password = "password123"
    user.password_confirmation = "password123"
    user.first_name = "Cleaner"
    user.last_name = "Test"
    user.phone = Faker::PhoneNumber.phone_number
    user.role = "cleaner"
  end
  if cleaner.new_record?
    cleaner.save!
    Rails.logger.info "Cleaner user created: #{cleaner.email}"
  else
    Rails.logger.info "Cleaner user already exists: #{cleaner.email}"
  end

  users = [ admin, user, manager, cleaner ]
end

# === TEAMS ===
teams = []
Rails.logger.info "Creating teams..." do
  [ "Windowshine" ].each do |name|
    team = Team.find_or_initialize_by(name: name) do |team|
      team.description = "#{name} is a team of window cleaners for commercial and house properties"
      team.status = "active"
    end

    if team.new_record?
      team.save!
      Rails.logger.info "Team created: #{team.name}"
    else
      Rails.logger.info "Team already exists: #{team.name}"
    end
    teams << team
  end
end

# === TEAM MEMBERSHIPS ===
team_memberships = []
Rails.logger.info "Creating team memberships..." do
  admin = users.first
  team = teams.first
  users.each_with_index do |u, i|
    team_membership = TeamMembership.find_or_initialize_by(user: u, team: team) do |membership|
      membership.role = u == admin ? "team_lead" : "member"
      membership.status = "active"
      membership.start_date = Date.current
      membership.end_date = Date.current + 1.year
    end

    if team_membership.new_record?
      team_membership.save!
      Rails.logger.info "Team membership created for user: #{u.email} in team: #{team.name}"
    else
      Rails.logger.info "Team membership already exists for user: #{u.email} in team: #{team.name}"
    end

    team_memberships << team_membership
  end
end

# === BUSINESSES ===
businesses = []
business_names = [ "Nike", "Adidas", "Under Armour" ]
Rails.logger.info "Creating businesses..." do
  business_names.each do |name|
    business = Business.find_or_initialize_by(name: name) do |business|
      business.address = Faker::Address.full_address
      business.phone = Faker::PhoneNumber.phone_number
      business.email = "#{name.downcase}@#{name.downcase}.com"
      business.notes = "#{name} is a company that sells stuff"
      business.status = "active"
    end

    if business.new_record?
      business.save!
      Rails.logger.info "Business created: #{business.name}"
    else
      Rails.logger.info "Business already exists: #{business.name}"
    end

    businesses << business
  end
end

# === TASKS ===
tasks = []
Rails.logger.info "Creating tasks..." do
  available_businesses = businesses.dup
  businesses.size.times do
    break if available_businesses.empty?

    business = available_businesses.delete(available_businesses.sample) # Get and remove a random business
    task = Task.find_or_initialize_by(title: "Tempalte Clean #{business.name}") do |t|
      t.description = "Teamplate description for #{business.name}"
      t.quantity = rand(1..10)
      t.location = Task::LOCATIONS.sample
      t.estimated_duration = rand(10..60)
      t.metadata = {}
    end

    if task.new_record?
      task.save!
      Rails.logger.info "Task created: #{task.title} for business: #{business.name}"
    else
      Rails.logger.info "Task already exists: #{task.title} for business: #{business.name}"
    end

    tasks << task
  end
end

# === RECURRING ASSIGNMENTS ===
recurring_assignments = []
Rails.logger.info "Creating recurring assignments..." do
  2.times do
    recurring_assignment = RecurringAssignment.find_or_initialize_by(
      recurrence_pattern: RecurringAssignment::RECURRENCE_PATTERNS.sample,
      is_active: true,
      is_recurring: true,
      recurrence_interval: 1,
      recurrence_end_date: Date.current + 1.year
    )

    if recurring_assignment.new_record?
      recurring_assignment.save!
      Rails.logger.info "Recurring assignment created: #{recurring_assignment.recurrence_pattern}"
    else
      Rails.logger.info "Recurring assignment already exists: #{recurring_assignment.recurrence_pattern}"
    end

    recurring_assignments << recurring_assignment
  end
end

# === CLEANING ASSIGNMENTS ===
cleaning_assignments = []
Rails.logger.info "Creating cleaning assignments..." do
  businesses.each_with_index do |business, i|
    team = teams.sample
    task = tasks[i % tasks.size]
    assigned_to = users.sample
    recurring_assignment = recurring_assignments.sample

    ca = CleaningAssignment.find_or_initialize_by(business: business, team: team)
    ca.scheduled_date = Date.current + i.days
    ca.total_estimated_duration_minutes = task.estimated_duration
    ca.actual_duration_minutes = nil
    ca.notes = "Initial cleaning assignment for #{business.name}"
    ca.metadata = {
      special_instructions: "Handle with care",
      requires_insurance_verification: [ true, false ].sample,
      number_of_windows: rand(2..8),
      number_of_floors: rand(1..2)
    }
    ca.assigned_to = assigned_to
    ca.recurring_assignment = recurring_assignment
    ca.tasks << task

    if ca.new_record?
      ca.save!
      Rails.logger.info "Cleaning assignment created for business: #{business.name}, team: #{team.name}, task: #{task.title}"
    else
      Rails.logger.info "Cleaning assignment already exists for business: #{business.name}, team: #{team.name}, task: #{task.title}"
    end

    cleaning_assignments << ca
  end
end

Rails.logger.info "Seeding completed!"
