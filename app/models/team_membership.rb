class TeamMembership < ApplicationRecord
  # Associations
  belongs_to :team
  belongs_to :user

  # Validations
  validates :team, presence: true
  validates :user, presence: true
end
