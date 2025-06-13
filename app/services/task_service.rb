# Service class to handle task-related operations
# frozen_string_literal: true

# This service class is responsible for grouping tasks based on their status
# for a given business_id or team_id resource.

class TaskService
  def initialize(resource:)
    @resource = resource # The Business or Team object
  end

  def grouped_tasks
    @resource.tasks.group_by(&:status)
  end
end
