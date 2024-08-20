class AddDateToRuns < ActiveRecord::Migration[7.1]
  def change
    add_column :runs, :date, :date
  end
end
