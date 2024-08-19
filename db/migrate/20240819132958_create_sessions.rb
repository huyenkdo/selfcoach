class CreateSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :sessions do |t|
      t.references :run, null: false, foreign_key: true
      t.date :date
      t.references :program, null: false, foreign_key: true
      t.string :status, default: "uncompleted"

      t.timestamps
    end
  end
end
