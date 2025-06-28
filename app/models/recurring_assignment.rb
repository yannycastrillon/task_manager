class RecurringAssignment < ApplicationRecord
  has_many :cleaning_assignments, dependent: :destroy

  # Constants for recurrence patterns
  DAILY = "daily"
  WEEKLY = "weekly"
  MONTHLY = "monthly"
  QUARTERLY = "quarterly"
  SEMIANNUALLY = "semiannually"
  ANNUALLY = "annually"

  RECURRENCE_PATTERNS = [ DAILY, WEEKLY, MONTHLY, QUARTERLY, SEMIANNUALLY, ANNUALLY ].freeze

  # Enums
  enum :recurrence_pattern, {
    daily: DAILY, weekly: WEEKLY, monthly: MONTHLY, quarterly: QUARTERLY, semiannually: SEMIANNUALLY, annually: ANNUALLY
  }

  # Validations
  validates :recurrence_pattern, presence: true, if: :is_recurring?
  validates :recurrence_pattern, inclusion: { in: RECURRENCE_PATTERNS }

  def is_recurring?
    is_recurring
  end
end
