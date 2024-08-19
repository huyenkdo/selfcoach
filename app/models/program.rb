class Program < ApplicationRecord
  belongs_to :user

  validates :objective_km, presence: true
  validates :race_date, presence: true
  validate :race_date_cannot_be_in_the_past
  validates :free_days, presence: true

  def race_date_cannot_be_in_the_past
    errors.add(:race_date, "ne peut pas être dans le passé") if
      !race_date.blank? && race_date < Date.today
  end
end
