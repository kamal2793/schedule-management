class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.references :doctor
      t.integer :day_of_week
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.date :start_date, null: false
      t.date :end_date
      t.boolean :is_available, null: false, default: true
      t.boolean :is_recurring, null: false, default: true
      t.text :recurrence_type, null: false
      t.integer :recurrence_step, null: false, default: 0

      t.timestamps
    end

    add_index :events, [:start_time, :end_time]
    add_index :events, [:start_date, :end_date]
    # add_index :events, [:is_recurring]
    # add_index :events, [:is_available]
  end
end
