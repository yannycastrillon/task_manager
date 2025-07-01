module CleaningAssignmentsHelper
  def valid_next_statuses
    {
      "scheduled" => [ "in_progress", "cancelled" ],
      "in_progress" => [ "completed", "cancelled" ],
      "completed" => [ "cancelled" ],
      "cancelled" => []
    }
  end
end
