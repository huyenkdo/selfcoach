class Program < ApplicationRecord
  attr_accessor :objective_time_hours, :objective_time_mins

  belongs_to :user

  validates :objective_km, presence: true
  validates :race_date, presence: true
  validate :race_date_cannot_be_in_the_past
  validates :free_days, presence: true
  validates :free_days, length: {
    minimum: 3,
    message: 'Il nous faudra au moins 3 jours de disponibilités par semaine pour pouvoir générer le programme'
  }, on: :create

  def race_date_cannot_be_in_the_past
    errors.add(:race_date, "ne peut pas être dans le passé") if
      !race_date.blank? && race_date < Date.today
  end
end
