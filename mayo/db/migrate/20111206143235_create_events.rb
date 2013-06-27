class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :enrollment_id
      t.integer :study_procedure_id
      t.datetime :event_start_time
      t.datetime :event_end_time
      t.integer :event_status
      t.integer :event_quality
      t.text :event_note
      t.string :key_person
      t.integer :ignore_event
      t.string :created_by
      t.string :updated_by
      t.integer :lock_version, :default => 0

      t.timestamps
    end
  end
end
