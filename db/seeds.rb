# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create default users
Rails.logger.info "Creating default users..."

# Create admin user
users = []
Rails.logger.info "Creating admin and regular users..." do
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
    Rails.logger.info "Created admin user: #{ENV["DEFAULT_ADMIN_EMAIL"]}"
  else
    Rails.logger.info "Admin user already exists"
  end

  # Create regular user
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
    Rails.logger.info "Created regular user: #{ENV["DEFAULT_USER_EMAIL"]}"
  else
    Rails.logger.info "Regular user already exists"
  end

  users << admin
  users << user
end

# Create team
teams = []
Rails.logger.info "Creating team..." do
  [ "Windowshine", "Houseshine" ].each do |name|
    team = Team.find_or_initialize_by(name: name) do |team|
      team.description = "#{name} is a team of window cleaners for comercial and house properties"
      team.status = "active"
    end

    if team.new_record?
      team.save!
      Rails.logger.info "Created team: #{team.name}"
    else
      Rails.logger.info "Team already exists"
    end
    teams << team
  end
end

team_memberships = []
Rails.logger.info "Creating team memberships..." do
  # Create team membership for admin user and regular user
  users.each_with_index do |user, index|
    team_membership = TeamMembership.find_or_initialize_by(user: user, team: teams[index]) do |membership|
      membership.role = user == admin ? "team_lead" : "member"
      membership.status = "active"
      membership.start_date = Date.current
      membership.end_date = Date.current + 1.year
    end

    # Create team membership for admin user and regular user
    if team_membership.new_record?
      team_membership.save!
      Rails.logger.info "Created team membership for #{user.email}"
    else
      Rails.logger.info "Team membership for #{user.email} already exists"
    end

    team_memberships << team_membership
  end
end

# Create business
businesses = []
Rails.logger.info "Creating business..." do
  [ "Nike", "Adidas", "Puma", "Reebok", "Under Armour" ].each do |name|
    business = Business.find_or_initialize_by(name: name) do |business|
      business.address = Faker::Address.full_address
      business.phone = Faker::PhoneNumber.phone_number
      business.email = "#{name.downcase}@#{name.downcase}.com"
      business.notes = "#{name} is a company that sells stuff"
      business.status = "active"
    end

    if business.new_record?
      business.save!
      Rails.logger.info "Created business: #{business.name}"
    else
      Rails.logger.info "Business already exists"
    end
    businesses << business
  end
end

# Create cleaning assignment
cleaning_assignments = []
Rails.logger.info "Creating cleaning assignment..." do
  businesses.each_with_index do |business, index|
    cleaning_assignment = CleaningAssignment.find_or_initialize_by(business: business, team: teams.sample) do |assignment|
      assignment.scheduled_date = Date.current
      assignment.status = "scheduled"
      assignment.price = Faker::Number.decimal(l_digits: 2)
    end

    if cleaning_assignment.new_record?
      cleaning_assignment.save!
      Rails.logger.info "Created cleaning assignment for #{business.name}"
    else
      Rails.logger.info "Cleaning assignment for #{business.name} already exists"
    end

    cleaning_assignments << cleaning_assignment
  end
end

# Create tasks
tasks = []
Rails.logger.info "Creating tasks..." do
  available_businesses = businesses.dup  # Create a copy of businesses array
  businesses.size.times do
    break if available_businesses.empty?  # Stop if we've used all businesses

    business = available_businesses.delete(available_businesses.sample)  # Get and remove a random business
    task = Task.find_or_initialize_by(title: "Clean #{business.name}") do |task|
      task.description = "Clean windows at #{business.name}"
      task.due_date = Date.current + rand(1..7).days
      task.priority = Task::PRIORITIES.sample
      task.status = Task::STATUSES.sample
      task.assigned_to = users.sample
      task.business = business
      task.team = teams.sample
    end

    if task.new_record?
      task.save!
      Rails.logger.info "Created task: #{task.title}"
    else
      Rails.logger.info "Task already exists: #{task.title}"
    end

    tasks << task
  end
end

Rails.logger.info "Seeding completed!"
