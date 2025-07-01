class Task < ApplicationRecord
  # Constants
  WINDOW = "window"
  FLOOR = "floor"
  ROOM = "room"
  OTHER = "other"
  LOCATIONS = [ WINDOW, FLOOR, ROOM, OTHER ].freeze

  # Associations
  has_many :cleaning_assignments, dependent: :destroy
  has_many :businesses, through: :cleaning_assignments
  has_many :teams, through: :cleaning_assignments
  # has_many :assigned_tos, through: :cleaning_assignments, class_name: "User", source: :assigned_to
  has_many :cleaning_assignment_tasks, dependent: :destroy
  has_many :cleaning_assignments, through: :cleaning_assignment_tasks

  # Enums
  enum :location, {
    window: WINDOW,
    floor: FLOOR,
    room: ROOM,
    other: OTHER
  }

  # Validations
  validates :title, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :location, inclusion: { in: LOCATIONS }
  validates :estimated_duration, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
end
