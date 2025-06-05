class Team < ApplicationRecord
  # Associations
  has_many :cleaning_assignments, dependent: :destroy
  has_many :businesses, through: :cleaning_assignments

  has_many :team_memberships, dependent: :destroy
  has_many :users, through: :team_memberships
  has_many :tasks, dependent: :destroy

  # Nested attributes
  accepts_nested_attributes_for :team_memberships, allow_destroy: true, reject_if: :all_blank

  # Validations
  validates :name, presence: true
  validates :status, presence: true

  # Callbacks
  after_save :update_team_memberships

  private

  def update_team_memberships
    return if user_ids.blank?

    # Remove memberships for users not in the list
    team_memberships.where.not(user_id: user_ids).destroy_all

    # Add memberships for new users
    user_ids.each do |user_id|
      team_memberships.find_or_create_by(user_id: user_id)
    end
  end
end
