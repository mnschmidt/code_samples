class CreateEnrollments < ActiveRecord::Migration
  def change
    create_table :enrollments do |t|
      t.integer :subject_id
      t.integer :study_id
      t.integer :study_of_origin
      t.date :study_entry_date
      t.integer :participant_status
      t.integer :group_id
      t.text :note
      t.string :created_by
      t.string :updated_by
      t.integer :lock_version, :default => 0

      t.timestamps
    end
  end
end
