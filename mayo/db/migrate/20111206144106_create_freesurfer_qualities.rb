class CreateFreesurferQualities < ActiveRecord::Migration
  def change
    create_table :freesurfer_qualities do |t|
      t.integer :initial_scan_quality_id
      t.integer :user_id
      t.integer :fs_segm_2d
      t.integer :fs_surf_2d
      t.integer :fs_pial_surf_3d
      t.integer :fs_wm_surf_3d
      t.integer :fs_infl_surf_3d
      t.text :note
      t.string :created_by
      t.string :updated_by
      t.integer :lock_version, :default => 0

      t.timestamps
    end
  end
end
