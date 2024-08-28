class AddStravaRunDataToRuns < ActiveRecord::Migration[7.1]
  def change
    add_column :runs, :real_total_km_ran, :float
    add_column :runs, :real_total_time_ran, :float
    add_column :runs, :real_avg_pace_ran, :float
  end
end
