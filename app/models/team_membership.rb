class TeamMembership < ApplicationRecord
  # Associations
  belongs_to :team
  belongs_to :user

  # Nested attributes
  accepts_nested_attributes_for :user

  # Validations
  validates :team, presence: true
  validates :user, presence: true
  validates :user_id, uniqueness: { scope: :team_id, message: "is already a member of this team" }
end
