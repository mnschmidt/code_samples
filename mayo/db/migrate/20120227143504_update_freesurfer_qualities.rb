class UpdateFreesurferQualities < ActiveRecord::Migration
  def up
    create_table :freesurfer_qualities do |t|
      t.integer :initial_scan_quality_id
      t.integer :user_id
      t.integer :all_segm_2d
      t.integer :all_surf_2d
      t.integer :all_pial_wm_surf_3d
      t.integer :all_infl_surf_3d
      t.integer :all_useable
      t.integer :left_segm_2d
      t.integer :left_surf_2d
      t.integer :left_pial_wm_surf_3d
      t.integer :left_infl_surf_3d
      t.integer :left_useable
      t.integer :right_segm_2d
      t.integer :right_surf_2d
      t.integer :right_pial_wm_surf_3d
      t.integer :right_infl_surf_3d
      t.integer :right_useable
      t.text :note
      t.string :created_by
      t.string :updated_by
      t.integer :lock_version, :default => 0

      t.timestamps
    end
  end

  def down
  end
end
