class CreateAvailabilities < ActiveRecord::Migration[5.1]
  def change
    create_table :availabilities do |t|
      t.date :date, null: false
      t.references :event
      t.references :doctor
      t.references :slot
      t.boolean :is_available, null: false, default: true

      t.timestamps
    end
  end
end
