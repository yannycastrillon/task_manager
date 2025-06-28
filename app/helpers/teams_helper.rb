module TeamsHelper
  def cleaning_assignments_in_progress_count(team)
    return 0 if team.cleaning_assignments.completed.empty?

    @in_progress_count ||= team.cleaning_assignments.in_progress.count
  end

  def cleaning_assignments_completed_count(team)
    return 0 if team.cleaning_assignments.completed.empty?

    @completed_count ||= team.cleaning_assignments.completed.count
  end

  def total_cleaning_assignments_count(team)
    return 0 if team.cleaning_assignments.empty?

    @total_count ||= team.cleaning_assignments.count
  end

  def cleaning_assignments_not_started_count(team)
    return 0 if team.cleaning_assignments.scheduled.empty?

    @not_started_count ||= team.cleaning_assignments.where(status: CleaningAssignment::SCHEDULED).count
  end

  def calculate_width_bar(team, status)
    total = total_cleaning_assignments_count(team)
    return 0 if total.zero?

    case status
    when :in_progress
      cleaning_assignments_in_progress_count(team)
    when :completed
      cleaning_assignments_completed_count(team)
    when :not_started
      cleaning_assignments_not_started_count(team)
    else
      0
    end
  end

  def cleaning_assignment_status_badge_component(status)
    return "" unless CleaningAssignment::STATUSES.include?(status)

    color, text = case status
    when CleaningAssignment::SCHEDULED
      [ "blue", CleaningAssignment::SCHEDULED.titleize ]
    when CleaningAssignment::IN_PROGRESS
      [ "amber", CleaningAssignment::IN_PROGRESS.titleize ]
    when CleaningAssignment::COMPLETED
      [ "emerald", CleaningAssignment::COMPLETED.titleize ]
    when CleaningAssignment::CANCELLED
      [ "red", CleaningAssignment::CANCELLED.titleize ]
    else
      [ "gray", "Unknown Status" ]
    end

    content_tag(:span, class: "inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-#{color}-500/20 text-#{color}-400 border border-#{color}-500/30") do
      content_tag(:div, "", class: "w-2 h-2 bg-#{color}-400 rounded-full mr-2 flex-shrink-0") + text
    end
  end

  def cleaning_assignment_priority_badge_component(priority)
    return "" unless CleaningAssignment::PRIORITIES.include?(priority)

    color, text = case priority
    when CleaningAssignment::LOW
      [ "emerald", CleaningAssignment::LOW.titleize ]
    when CleaningAssignment::MEDIUM
      [ "amber", CleaningAssignment::MEDIUM.titleize ]
    when CleaningAssignment::HIGH
      [ "red", CleaningAssignment::HIGH.titleize ]
    else
      [ "gray", "Unknown Priority" ]
    end

    content_tag(:span, class: "inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-#{color}-500/20 text-#{color}-400 border border-#{color}-500/30") do
      content_tag(:div, "", class: "w-2 h-2 bg-#{color}-400 rounded-full mr-2 flex-shrink-0") + text
    end
  end
end
