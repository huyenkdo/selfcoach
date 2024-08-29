class RunningSession < ApplicationRecord
  attr_accessor :free_or_not, :kind, :run_interval_km, :rest_interval_time, :run_interval_nbr, :run_interval_time

  belongs_to :run
  belongs_to :program
end
