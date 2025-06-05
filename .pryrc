# Load Rails environment
if defined?(Rails)
  require 'rails/console/app'
  require 'rails/console/helpers'
end

# Show more lines in the stack trace
Pry.config.print.limit = 100

# Enable syntax highlighting
Pry.config.color = true

# Enable history
Pry.config.history.file = "~/.pry_history"
Pry.config.history.should_save = true
Pry.config.history.should_load = true

# Enable auto-indentation
Pry.config.auto_indent = true

# Enable command history
Pry.config.commands.alias_command 'h', 'history'

# Add some useful commands
Pry.commands.alias_command 'c', 'continue'
Pry.commands.alias_command 's', 'step'
Pry.commands.alias_command 'n', 'next'
Pry.commands.alias_command 'f', 'finish'
Pry.commands.alias_command 'b', 'break'
Pry.commands.alias_command 'q', 'exit'
