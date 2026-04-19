# Windowshine Task Manager

A Rails 8 web application for managing window cleaning operations — businesses, teams, tasks, and cleaning assignments — with role-based access control.

## Features

- **Businesses** — track client businesses with contact info and status
- **Teams** — organize cleaners into teams with memberships and roles
- **Tasks** — define cleaning jobs with location, duration, and quantity
- **Cleaning Assignments** — schedule and assign jobs to teams and cleaners, with support for recurring assignments
- **Role-based access control** via CanCanCan:
  - `admin` — full access
  - `manager` — manage businesses, teams, tasks, and assignments
  - `cleaner` — view and update own assignments
  - `user` — read-only access to businesses, teams, and own assignments

## Tech Stack

- Ruby 3.3.5
- Rails 8.0.2
- PostgreSQL
- Tailwind CSS (via tailwindcss-rails)
- Stimulus / Importmap
- CanCanCan for authorization

## Setup

**1. Clone and install dependencies**

```bash
git clone <repo-url>
cd task_manager
bundle install
```

**2. Configure environment variables**

Create a `.env` file in the project root:

```
DEFAULT_ADMIN_EMAIL=admin@example.com
DEFAULT_ADMIN_PASSWORD=yourpassword

DEFAULT_USER_EMAIL=user@example.com
DEFAULT_USER_PASSWORD=yourpassword
```

**3. Set up the database**

```bash
bin/rails db:create db:migrate db:seed
```

**4. Start the development server**

```bash
bin/dev
```

This runs both the Rails server and the Tailwind CSS watcher. Open [http://localhost:3000](http://localhost:3000).

> Do **not** use `rails server` alone — Tailwind CSS requires its watcher process to compile styles in development.

## Seed Accounts

After running `db:seed`, the following test accounts are available:

| Role    | Email             | Password    |
|---------|-------------------|-------------|
| Admin   | *(from .env)*     | *(from .env)* |
| Manager | manager@test.com  | password123 |
| Cleaner | cleaner@test.com  | password123 |
| User    | *(from .env)*     | *(from .env)* |
