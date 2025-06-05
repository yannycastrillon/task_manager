class Team < ApplicationRecord
  # Associations
  has_many :cleaning_assignments, dependent: :destroy
  has_many :businesses, through: :cleaning_assignments

  has_many :team_memberships, dependent: :destroy
  has_many :users, through: :team_memberships
  has_many :tasks, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :status, presence: true
end
