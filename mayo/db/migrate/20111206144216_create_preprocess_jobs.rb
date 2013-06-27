class CreatePreprocessJobs < ActiveRecord::Migration
  def change
    create_table :preprocess_jobs do |t|
      t.integer :event_id
      t.string :sequence
      t.integer :slice_count
      t.integer :volume_count
      t.text :note
      t.string :created_by
      t.string :updated_by
      t.integer :lock_version, :default => 0

      t.timestamps
    end
  end
end
