class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.string :first_name
      t.string :last_name
      t.date :date_of_birth
      t.integer :sex
      t.integer :research_status
      t.integer :race_id
      t.integer :ethnicity_id
      t.text :note
      t.string :created_by
      t.string :updated_by
      t.integer :lock_version, :default => 0

      t.timestamps
    end
  end
end
