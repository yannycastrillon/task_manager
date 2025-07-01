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
  validates :recurrence_pattern, presence: true, inclusion: { in: RECURRENCE_PATTERNS }
  validates :recurrence_interval, presence: true, numericality: { greater_than: 0 }

  # Callbacks
  before_validation :deactivate_if_past_end_date

  def is_recurring?
    is_recurring
  end

  def is_active?
    is_active
  end

  def expired?
    recurrence_end_date.present? && recurrence_end_date < Time.zone.today
  end

  def next_scheduled_date(base_date = Time.zone.today)
    return unless is_recurring? && is_active? && recurrence_interval.present? && expired?.blank?

    interval = recurrence_interval
    case recurrence_pattern
    when DAILY
      base_date + interval.days
    when WEEKLY
      base_date + interval.weeks
    when MONTHLY
      base_date + interval.months
    when QUARTERLY
      base_date + (interval * 3).months
    when SEMIANNUALLY
      base_date + (interval * 6).months
    when ANNUALLY
      base_date + interval.years
    else
      nil
    end
  end

  def expiration_warning_message
    return unless expired?

    "This recurring schedule has expired and is now inactive."
  end

  private

  def deactivate_if_past_end_date
    if recurrence_end_date.present? && recurrence_end_date < Time.zone.today
      self.is_active = false
    end
  end
end
