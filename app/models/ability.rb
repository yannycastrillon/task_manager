# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Return early if no user is present
    return if user.blank?

    # Admin users have full access to all resources
    if user.admin?
      can :manage, :all
    # Manager users can manage most resources except user management
    elsif user.manager?
      can :manage, [ Business, Team, Task, CleaningAssignment ]
      can :read, User
    # Cleaner users can view and update their own assignments
    elsif user.cleaner?
      can :read, [ CleaningAssignment, Task ]
      can :update, CleaningAssignment, assigned_to_id: user.id
    # Regular users have minimal access
    elsif user.user?
      can :read, [ Business, Team, Task ]
      can :read, CleaningAssignment, assigned_to_id: user.id
    end
  end
end
