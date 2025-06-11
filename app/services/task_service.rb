# Service class to handle task-related operations
# frozen_string_literal: true

# This service class is responsible for grouping tasks based on their status
# for a given business_id or team_id resource.

class TaskService
  def initialize(resource_id:, resource_type:)
    @resource_id = resource_id # ID of the business or team
    @resource_type = resource_type # Type of resource, either :business or :team
  end

  def grouped_tasks
    case @resource_type
    when :business
      Task.where(business_id: @resource_id).group_by(&:status)
    when :team
      Task.where(team_id: @resource_id).group_by(&:status)
    else
      raise ArgumentError, "Invalid resource type: #{@resource_type}"
    end
  end
end
