class CreateInitialScanQualities < ActiveRecord::Migration
  def change
    create_table :initial_scan_qualities do |t|
      t.integer :event_id
      t.integer :sequence_id
      t.integer :rating
      t.integer :rater
      t.text :note
      t.string :created_by
      t.string :updated_by
      t.integer :lock_version, :default => 0

      t.timestamps
    end
  end
end
