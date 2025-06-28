class Business < ApplicationRecord
  # Associations
  has_many :cleaning_assignments, dependent: :destroy
  has_many :teams, through: :cleaning_assignments
  has_many :users, through: :cleaning_assignments
  has_many :tasks, through: :cleaning_assignments

  # Validations
  validates :name, presence: true
  validates :status, presence: true

  # Scopes
  scope :active, -> { where(status: :active) }
  scope :inactive, -> { where(status: :inactive) }

  def website
    "https://#{name.downcase.gsub(" ", "-")}.com"
  end
end
