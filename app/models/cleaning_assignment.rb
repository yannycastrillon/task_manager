class CleaningAssignment < ApplicationRecord
  # Constants
  SCHEDULED = "scheduled"
  IN_PROGRESS = "in_progress"
  COMPLETED = "completed"
  CANCELLED = "cancelled"
  STATUSES = [ SCHEDULED, IN_PROGRESS, COMPLETED, CANCELLED ].freeze

  LOW = "low"
  MEDIUM = "medium"
  HIGH = "high"
  PRIORITIES = [ LOW, MEDIUM, HIGH ].freeze

  # Associations
  belongs_to :team
  belongs_to :business
  belongs_to :recurring_assignment, optional: true
  belongs_to :assigned_to, class_name: "User", optional: true
  has_many :cleaning_assignment_tasks, dependent: :destroy
  has_many :tasks, through: :cleaning_assignment_tasks

  # Enums
  enum :status, { scheduled: SCHEDULED, in_progress: IN_PROGRESS, completed: COMPLETED, cancelled: CANCELLED }.freeze
  enum :priority, { low: LOW, medium: MEDIUM, high: HIGH }.freeze

  # Validations
  validates :status, inclusion: { in: STATUSES }
  validates :scheduled_date, presence: true
  # validates :scheduled_date, timeliness: { on_or_after: -> { Date.current }, type: :date }
  validates :total_estimated_duration_minutes, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :actual_duration_minutes, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

  # Scopes
  scope :active, -> { where(status: [ SCHEDULED, IN_PROGRESS ]) }
  scope :completed, -> { where(status: COMPLETED) }
  scope :cancelled, -> { where(status: CANCELLED) }
  scope :in_progress, -> { where(status: IN_PROGRESS) }

  # Callbacks
  before_validation :set_default_values

  accepts_nested_attributes_for :recurring_assignment, allow_destroy: true

  private

  def set_default_values
    self.status ||= SCHEDULED
    self.total_estimated_duration_minutes ||= 0
    self.actual_duration_minutes ||= 0
    self.metadata ||= { number_of_floors: nil, number_of_windows: nil, special_instructions: nil }
  end

  # Class methods
  def self.assignments_days(date = Date.current)
    CleaningAssignment.includes(:business, :team)
                      .where(scheduled_date: date.all_day)
                      .order(scheduled_date: :asc)
  end

  def self.current_week_assignments(date = Date.current, start_of_week = date.beginning_of_week, end_of_week = date.end_of_week)
    today = date
    tomorrow = today + 1.day
    CleaningAssignment.includes(:business, :team)
                      .where("scheduled_date >= ? AND scheduled_date <= ? AND scheduled_date NOT IN (?, ?)", start_of_week, end_of_week, date, tomorrow)
                      .order(scheduled_date: :asc)
  end
end
