class Run < ApplicationRecord
  has_many :sessions, class_name: 'RunningSession'

  validates :hr_zone, presence: true
  validates :difficulty, presence: true
  validates :kind, presence: true

  def total_time
    case kind
    when "Interval" || "Tempo"
      run_time = run_interval_time || 0
      rest_time = rest_interval_time || 0
      intervals = run_interval_nbr || 1
      (run_time * intervals) + (rest_time * (intervals - 1))
    when "Easy" || "Long"
      run_interval_km * run_interval_pace
    else
      10
    end
  end

  def warmup_time
    if kind == "interval"
      20
    else
      5
    end
  end

  def warmup_pace
    (run_interval_pace * 1.10).round(2)
  end

  def session_details
    case kind
    when "Interval"
      {
        intervals: run_interval_nbr,
        interval_distance: run_interval_km,
        interval_pace: run_interval_pace,
        rest_pace: rest_interval_pace,
        difficulty: difficulty
      }
    when "Easy", "Long run"
      {
        distance: run_interval_km,
        pace: run_interval_pace,
        difficulty: difficulty
      }
    else
      {}
    end
  end


  def formatted_time(time)
    return "0 min" if time.nil?

    if time >= 60
      hours = time.to_i / 60
      minutes = time.to_i % 60
      "#{hours}h #{minutes}min"
    else
      "#{time.to_i} min"
    end
  end
end
