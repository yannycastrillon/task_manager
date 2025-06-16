class HomeController < ApplicationController
  allow_unauthenticated_access

  def index
    @today = Date.current
    @start_of_week = @today.beginning_of_week
    @end_of_week = @today.end_of_week

    # Fetch today's cleaning assignments
    @today_cleaning_assignments = CleaningAssignment.includes(:business, :team)
                                    .where(scheduled_date: @today.all_day)
                                    .order(scheduled_date: :asc)

    # Fetch tomorrow's cleaning assignments
    @tomorrow_cleaning_assignments = CleaningAssignment.includes(:business, :team)
                                       .where(scheduled_date: (@today + 1.day).all_day)
                                       .order(scheduled_date: :asc)

    # Fetch current week's cleaning assignments (excluding today and tomorrow)
    @current_week_cleaning_assignments = CleaningAssignment.includes(:business, :team)
                                           .where(scheduled_date: (@start_of_week..@end_of_week))
                                           .where.not(scheduled_date: @today.all_day)
                                           .where.not(scheduled_date: (@today + 1.day).all_day)
                                           .order(scheduled_date: :asc)
  end
end
