class CreateStudies < ActiveRecord::Migration
  def change
    create_table :studies do |t|
      t.string :title
      t.string :description
      t.integer :user_id
      t.integer :status
      t.date :start_date
      t.date :end_date
      t.text :note
      t.string :created_by
      t.string :updated_by
      t.integer :lock_version, :default => 0

      t.timestamps
    end
  end
end
