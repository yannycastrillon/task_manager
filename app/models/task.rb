class Task < ApplicationRecord
  # Constants
  LOW = "low"
  MEDIUM = "medium"
  HIGH = "high"

  NOT_STARTED = "not_started"
  IN_PROGRESS = "in_progress"
  COMPLETED = "completed"
  CANCELLED = "cancelled"

  PRIORITIES = [ LOW, MEDIUM, HIGH ].freeze
  STATUSES = [ NOT_STARTED, IN_PROGRESS, COMPLETED, CANCELLED ].freeze

  # Associations
  belongs_to :business
  belongs_to :team
  belongs_to :assigned_to, class_name: "User", optional: true

  # Validations
  validates :title, presence: true
  validates :status, presence: true
  validates :priority, presence: true
  validates :due_date, presence: true
  validates :priority, inclusion: { in: PRIORITIES }
  validates :status, inclusion: { in: STATUSES }

  # Enums
  enum :status, { not_started: NOT_STARTED, in_progress: IN_PROGRESS,
                  completed: COMPLETED, cancelled: CANCELLED }
  enum :priority, { low: LOW, medium: MEDIUM, high: HIGH }

  # Scopes
  scope :due_today, -> { where(due_date: Date.current) }
  scope :overdue, -> { where("due_date < ?", Date.current).where.not(status: :completed) }
  scope :upcoming, -> { where("due_date > ?", Date.current) }
end
