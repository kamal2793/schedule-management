class CreateAppointments < ActiveRecord::Migration[5.1]
  def change
    create_table :appointments do |t|
      t.references :doctor
      t.references :patient
      t.references :slot
      t.datetime :appointment_date, null: false
      t.text :status, null: false

      t.timestamps
    end
  end
end
