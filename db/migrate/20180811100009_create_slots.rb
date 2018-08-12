class CreateSlots < ActiveRecord::Migration[5.1]
  def change
    create_table :slots do |t|
      t.time :start_time, null: false
      t.time :end_time, null: false

      t.timestamps
    end

    add_index :slots, [:start_time, :end_time], unique: true
  end
end
