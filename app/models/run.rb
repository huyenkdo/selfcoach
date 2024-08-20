class Run < ApplicationRecord
  has_many :sessions

  validates :date, presence: true
  validates :run_interval_km, presence: true
  validates :run_interval_time, presence: true
  validates :run_interval_pace, presence: true
  validates :rest_interval_km, presence: true
  validates :rest_interval_time, presence: true
  validates :rest_interval_pace, presence: true
  validates :hr_zone, presence: true
  validates :difficulty, presence: true
  validates :kind, presence: true
  validates :run_interval_nbr, presence: true

  def total_time
    run_time = run_interval_time || 0
    rest_time = rest_interval_time || 0
    intervals = run_interval_nbr || 1

    (run_time * intervals) + (rest_time * (intervals - 1))
  end
end
