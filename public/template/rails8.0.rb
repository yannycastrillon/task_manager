require "rails/generators"
require "rails/generators/actions"

class Base < Rails::Generators::Base
  source_root File.expand_path("..", __dir__)

  def rails_command(command)
    run "rails #{command}"
  end

  def bundle_install
    run "bundle install"
  end

  def update_database
    # Run database migrations
    rails_command "db:migrate"

    # Keep test database in sync
    rails_command "db:test:prepare"
  end

  def cops_autofix
    run "bundle exec rubocop -a"
  end
end

class CommonGems < Base
  def execute
    add_common_development_gems
    bundle_install
    setup_rspec
    setup_rubocop
    setup_guard
    setup_factory_bot
    cops_autofix
  end

  private

  # Add gems for RSpec, Rubocop, FactoryBot, and Guard
  def add_common_development_gems
    inject_into_file "Gemfile", after: "group :development, :test do\n" do
      <<-GEMS
  gem "rspec-rails", "~> 7.1.1"
  gem "factory_bot_rails", "~> 6.4"
  gem "guard", "~> 2.18"
  gem "guard-rspec", "~> 4.7"
  gem "rubocop", "~> 1.75", require: false
  gem "rubocop-rails", "~> 2.32", require: false
  gem "pry", "~>0.15"
  gem "pry-byebug", "~> 3.11"
  gem "pry-rails", "~> 0.3.11"
  gem 'tailwindcss-rails', '~> 4.2', '>= 4.2.3'
      GEMS
    end
  end

  def setup_rspec
    rails_command "generate rspec:install"
    append_to_file ".rspec", "--format documentation"

    # Add FactoryBot configuration to RSpec
    inject_into_file "spec/rails_helper.rb", after: "RSpec.configure do |config|\n" do
      "  config.include FactoryBot::Syntax::Methods\n"
    end
  end

  def setup_rubocop
    create_file ".rubocop.yml", force: true do
      <<-YML
  # Omakase Ruby styling for Rails
  inherit_gem:
    rubocop-rails-omakase: rubocop.yml

  require:
    - rubocop-rails

  AllCops:
    TargetRubyVersion: 3.0
    Exclude:
      - "db/schema.rb"
      - "bin/*"
      - "node_modules/**/*"
      - "config/**/*"
      - "vendor/**/*"

  Layout/LineLength:
    Max: 200

  Rails:
    Enabled: true
      YML
    end
  end

  def setup_guard
    run "bundle exec guard init rspec"
  end

  # Additional setup for FactoryBot (optional, since it is already configured with RSpec)
  def setup_factory_bot
    # FactoryBot is configured with RSpec
  end
end

class HomePage < Base
  def execute
    rails_command "generate controller home index --skip-routes"
    set_root_to_home
    add_view
  end

  def set_root_to_home
    gsub_file "config/routes.rb", /# root "posts#index"/, "root 'home#index'"
  end
  
  def add_view
    create_file "app/views/home/index.html.erb", force: true do
      <<-ERB
  <div class="min-h-screen flex flex-col justify-center items-center bg-gradient-to-r from-indigo-100 via-purple-100 to-pink-100 px-4">
    <div class="bg-white p-8 sm:p-12 rounded-lg shadow-xl w-full max-w-screen-lg mx-auto text-center">
      <h1 class="text-4xl sm:text-5xl font-extrabold text-gray-900 mb-6 sm:mb-8">Rails 8 - Task Manager</h1>
      <p class="text-base sm:text-lg text-gray-600 mb-6 sm:mb-8">
        A platform to explore Rails 8 features. Use the links below to navigate.
      </p>

  <!-- Link Pages -->

  <!-- Link Letter Opener -->

    </div>
  </div>
      ERB
    end
  end
end

class Layout < Base
  def execute
    update_application_layout
    add_menu
  end

  def add_menu
    create_file "app/views/shared/_menu.html.erb" do
      <<-ERB
  <ul class="w-64 text-lg font-semibold text-gray-700">
    <li class="border border-gray-300 rounded-lg hover:shadow-lg transition-shadow duration-200">
      <%= link_to "Home", root_path, class: "block px-6 py-3 text-center hover:bg-blue-500 hover:text-white rounded-lg" %>
    </li>
  
    <% if Rails.application.routes.url_helpers.respond_to?(:pages_about_path) %>
      <li class="border border-gray-300 rounded-lg hover:shadow-lg transition-shadow duration-200">
        <%= link_to "About Page", pages_about_path, class: "block px-6 py-3 text-center bg-green-100 hover:bg-blue-500 hover:text-white rounded-lg" %>
      </li>
    <% end %>
  
    <% if Rails.application.routes.url_helpers.respond_to?(:pages_authentification_path) %>
      <li class="border border-gray-300 rounded-lg hover:shadow-lg transition-shadow duration-200">
        <%= link_to "Authentication Page", pages_authentification_path, class: "block px-6 py-3 text-center bg-yellow-100 hover:bg-blue-500 hover:text-white rounded-lg" %>
      </li>
    <% end %>
  
    <% if Rails.application.routes.url_helpers.respond_to?(:pages_account_path) %>
      <li class="border border-gray-300 rounded-lg hover:shadow-lg transition-shadow duration-200">
        <%= link_to "Account Page", pages_account_path, class: "block px-6 py-3 text-center bg-red-100  hover:bg-blue-500 hover:text-white rounded-lg" %>
      </li>
    <% end %>
  
    <% if Rails.application.routes.url_helpers.respond_to?(:letter_opener_web_path) && Rails.env.development? %>
      <li class="border border-gray-300 rounded-lg hover:shadow-lg transition-shadow duration-200">
        <%= link_to "Check Email", letter_opener_web_path, target: "_blank", class: "block px-6 py-3 text-center bg-gray-100 hover:bg-blue-500 hover:text-white rounded-lg" %>
      </li>
    <% end %>
  </ul>
      ERB
    end
  end

  def update_application_layout
    gsub_file "app/views/layouts/application.html.erb", /<body[^>]*>(.*?)<\/body>/ do
      <<-ERB
  <body>
    <main class="flex justify-center items-center min-h-screen">
      <!-- {Flash} -->
      <%= render "shared/menu" %>
      <div class="w-full max-w-screen-lg px-4">
        <%= yield %>
      </div>
    </main>
  </body>
      ERB
    end
  end
end

class Flash < Base
  def execute
    add_flash_messages
    add_flash_to_layout
  end

  def add_flash_messages
    create_file "app/views/shared/_flash.html.erb" do
    <<-ERB
  <% flash.each do |type, message| %>
    <%# Map flash types to corresponding Tailwind CSS classes %>
    <% flash_class = case type
        when "notice" then "bg-green-100 text-green-800 border-green-300"
        when "alert" then "bg-red-100 text-red-800 border-red-300"
        else "bg-gray-100 text-gray-800 border-gray-300"
      end %>

    <div class="border-l-4 p-4 mb-4 <%= flash_class %>">
      <p><%= message %></p>
    </div>
  <% end %>
    ERB
    end
  end

  def add_flash_to_layout
    gsub_file "app/views/layouts/application.html.erb", "<!-- {Flash} -->", '<%= render "shared/flash" %>'
  end
end

class AppplicationSettings < Base
  def execute
    add_generator_settings
  end

  def add_generator_settings
    gsub_file 'config/application.rb', /config.generators.system_tests = nil/m do
      <<-RUBY
    config.generators do |g|
      g.test_framework :rspec,                # Set RSpec as the test framework
                        fixtures: true,       # Generate fixtures (or factories)
                        view_specs: false,    # Generate view specs
                        helper_specs: false,  # Don't generate helper specs
                        routing_specs: false, # Generate routing specs
                        request_specs: true,  # Generate request specs
                        system_tests: nil     # Disable system test generation inside this block

      # Use FactoryBot for generating test data
      g.fixture_replacement :factory_bot, dir: "spec/factories"
      g.helper false                         # Disable helper generation
    end
      RUBY
    end
  end
end

def run_menu(menu)
  puts "Select an action by number:"
  menu.each { |item| puts "#{item[:id]}. #{item[:label]}" }

  choice = ask "Enter a number: "
  menu_item = menu.find { |item| item[:id] == choice.to_i }

  if menu_item
    puts "Running: #{menu_item[:label]}"

    if menu_item[:customizations]
      menu_item[:customizations].new.execute
    else
      exit_program
    end
  else
    puts "Invalid choice. Please enter a valid number."
  end
end

order = 0
menu = [
  { id: (order+=1), label: 'Common Gems', customizations: CommonGems },
  { id: (order+=1), label: 'Home Page', customizations: HomePage },
  { id: (order+=1), label: 'Layout', customizations: Layout },
  { id: (order+=1), label: 'Flash Messages', customizations: Flash },
  { id: (order+=1), label: 'Application Settings', customizations: AppplicationSettings },
  # { id: (order+=1), label: 'Top Level Pages', customizations: TopLevelPages },
  # { id: (order+=1), label: 'Rails Generate Authentication', customizations: RailsGenerateAuthentication },
  # { id: (order+=1), label: 'Authentication Relax Restrictions', customizations: AuthenticationRelaxRestrictions },
  # { id: (order+=1), label: 'AuthenticationEnhancement', customizations: AutheticationEnhancement },
  # { id: (order+=1), label: 'Authentication Info', customizations: AutheticationInfo },
  # { id: (order+=1), label: 'Move Mailer using Cursor AI', customizations: CursorAI },
  # { id: (order+=1), label: 'Authetication Email', customizations: AutheticationEmail },
  # { id: (order+=1), label: 'Authetication Email Mailer', customizations: AutheticationEmailMailer },
  { id: 0, label: 'Exit', customizations: nil }
]

run_menu(menu)
