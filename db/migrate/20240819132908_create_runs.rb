class CreateRuns < ActiveRecord::Migration[7.1]
  def change
    create_table :runs do |t|
      t.float :run_interval_km
      t.float :run_interval_time
      t.float :run_interval_pace
      t.float :rest_interval_km
      t.float :rest_interval_time
      t.float :rest_interval_pace
      t.string :hr_zone
      t.integer :difficulty
      t.string :kind
      t.integer :run_interval_nbr

      t.timestamps
    end
  end
end
