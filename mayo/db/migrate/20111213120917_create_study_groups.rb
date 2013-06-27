class CreateStudyGroups < ActiveRecord::Migration
  def change
    create_table :study_groups do |t|
      t.integer :study_id
      t.string :name

      t.timestamps
    end
  end
end
