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
  accepts_nested_attributes_for :recurring_assignment, allow_destroy: true
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
  before_update :set_started_and_completed_times
  after_update :create_next_recurring_assignment, if: :should_create_next_recurring_assignment?

  accepts_nested_attributes_for :recurring_assignment, allow_destroy: true


  def real_time_spent_human
    return nil unless started_at && completed_at

    seconds = completed_at - started_at
    minutes = (seconds / 60).to_i
    hours = minutes / 60
    mins = minutes % 60

    hours.positive? ? "#{hours}h #{mins}m" : "#{mins}m"
  end

  def create_next_recurring_assignment
    return unless recurring_assignment

    next_date = recurring_assignment.next_scheduled_date(scheduled_date || Time.zone.today)
    return unless next_date

    CleaningAssignment.create!(duplication_attributes_for_next(next_date))
  end

  private

  def set_default_values
    self.status ||= SCHEDULED
    self.total_estimated_duration_minutes ||= 0
    self.actual_duration_minutes ||= 0
    self.metadata ||= { number_of_floors: nil, number_of_windows: nil, special_instructions: nil }
  end

  def set_started_and_completed_times
    return unless status_changed?

    time_now = Time.zone.now
    self.started_at = time_now if status == IN_PROGRESS && started_at.nil?
    self.completed_at = time_now if status == COMPLETED && completed_at.nil?
  end

  def should_create_next_recurring_assignment?
    saved_change_to_status? && status == COMPLETED &&
      recurring_assignment&.is_recurring? && recurring_assignment&.is_active?
  end

  def duplication_attributes_for_next(next_date)
    attributes.symbolize_keys
              .except(:id, :created_at, :updated_at, :status, :started_at, :completed_at)
              .merge(status: SCHEDULED, scheduled_date: next_date, recurring_assignment_id: recurring_assignment.id)
  end

  # Class methods
  def self.assignments_days(date = Time.zone.today)
    CleaningAssignment.includes(:business, :team)
                      .where(scheduled_date: date.all_day)
                      .order(scheduled_date: :asc)
  end

  def self.current_week_assignments(date = Time.zone.today, start_of_week = date.beginning_of_week, end_of_week = date.end_of_week)
    today = date
    tomorrow = today + 1.day
    CleaningAssignment.includes(:business, :team)
                      .where("scheduled_date >= ? AND scheduled_date <= ? AND scheduled_date NOT IN (?, ?)", start_of_week, end_of_week, date, tomorrow)
                      .order(scheduled_date: :asc)
  end
end
