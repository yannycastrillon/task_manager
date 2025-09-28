class HomeController < ApplicationController
  skip_authorization_check

  def index
    assignment_service = CleaningAssignmentService.new(today: Date.current)

    @today = assignment_service.today
    @start_of_week = assignment_service.start_of_week
    @end_of_week = assignment_service.end_of_week

    @today_cleaning_assignments = assignment_service.today_assignments
    @tomorrow_cleaning_assignments = assignment_service.tomorrow_assignments
    @current_week_cleaning_assignments = assignment_service.current_week_assignments
  end
end
