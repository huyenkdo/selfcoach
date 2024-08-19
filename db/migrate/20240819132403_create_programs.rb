class CreatePrograms < ActiveRecord::Migration[7.1]
  def change
    create_table :programs do |t|
      t.float :objective_km
      t.float :objective_time
      t.date :race_date
      t.string :free_days, array: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
