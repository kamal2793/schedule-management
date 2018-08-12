class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.references :doctor
      t.integer :day_of_week
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.date :start_date, null: false
      t.date :end_date
      t.boolean :is_available, default: true
      t.boolean :is_recurring, default: false
      t.text :recurrence_type, null: false
      t.integer :recurrence_step

      t.timestamps
    end
  end
end
