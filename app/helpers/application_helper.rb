module ApplicationHelper
  # Helper method to check if user can perform an action on a resource
  def can_perform_action?(action, resource)
    return false unless authenticated?

    can?(action, resource)
  end

  # Helper method to check if user can manage a resource
  def can_manage?(resource)
    can_perform_action?(:manage, resource)
  end

  # Helper method to check if user can create a resource
  def can_create?(resource)
    can_perform_action?(:create, resource)
  end

  # Helper method to check if user can update a resource
  def can_update?(resource)
    can_perform_action?(:update, resource)
  end

  # Helper method to check if user can destroy a resource
  def can_destroy?(resource)
    can_perform_action?(:destroy, resource)
  end
end
