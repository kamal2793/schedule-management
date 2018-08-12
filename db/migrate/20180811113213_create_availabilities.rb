class CreateAvailabilities < ActiveRecord::Migration[5.1]
  def change
    create_table :availabilities do |t|
      t.datetime :date
      t.references :event
      t.references :slot
      t.boolean :is_available

      t.timestamps
    end
  end
end
