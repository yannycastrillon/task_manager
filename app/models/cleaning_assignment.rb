class CleaningAssignment < ApplicationRecord
  # Constants
  SCHEDULED = "scheduled"
  IN_PROGRESS = "in_progress"
  COMPLETED = "completed"
  CANCELLED = "cancelled"

  DAILY = "daily"
  WEEKLY = "weekly"
  BI_WEEKLY = "bi_weekly"
  TRI_WEEKLY = "tri_weekly"
  MONTHLY = "monthly"
  QUARTERLY = "quarterly"
  SEMI_ANNUALLY = "semi_annually"
  ANNUALLY = "annually"

  RECURRENCE_PATTERNS = [ nil, DAILY, WEEKLY, BI_WEEKLY, TRI_WEEKLY, MONTHLY, QUARTERLY, SEMI_ANNUALLY, ANNUALLY ].freeze
  STATUSES = [ SCHEDULED, IN_PROGRESS, COMPLETED, CANCELLED ].freeze

  # Associations
  belongs_to :team
  belongs_to :business

  validates :recurrence_pattern, presence: true, if: :is_recurring?
  validates :recurrence_pattern, inclusion: { in: RECURRENCE_PATTERNS }
  validates :status, inclusion: { in: STATUSES }

  # Enums
  enum :status, { scheduled: SCHEDULED, in_progress: IN_PROGRESS, completed: COMPLETED, cancelled: CANCELLED }
  enum :recurrence_pattern, {
    daily: DAILY, weekly: WEEKLY, bi_weekly: BI_WEEKLY,
    tri_weekly: TRI_WEEKLY, monthly: MONTHLY,
    quarterly: QUARTERLY, semi_annually: SEMI_ANNUALLY, annually: ANNUALLY
  }
end
