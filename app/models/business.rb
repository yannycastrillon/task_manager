class Business < ApplicationRecord
  # Associations
  has_many :teams, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :cleaning_assignments, through: :teams
  has_many :users, through: :cleaning_assignments

  # Validations
  validates :name, presence: true
  validates :status, presence: true

  # Scopes
  scope :active, -> { where(status: :active) }
  scope :inactive, -> { where(status: :inactive) }
end
