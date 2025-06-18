class CleaningAssignmentService
  attr_reader :today, :start_of_week, :end_of_week

  def initialize(today: Date.current)
    @today = today
    @start_of_week = today.beginning_of_week
    @end_of_week = today.end_of_week
  end

  def today_assignments
    CleaningAssignment.assignments_days(@today)
  end

  def tomorrow_assignments
    CleaningAssignment.assignments_days(@today + 1.day)
  end

  def current_week_assignments
    CleaningAssignment.current_week_assignments(@today)
  end
end
