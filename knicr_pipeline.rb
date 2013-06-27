#!/usr/bin/env ruby

#######################################################################################
# This script is used to run the preprocessing pipeline for the r_number cannabis study
#
# Date Created: 11/02/2010
# Last Edited:  11/01/2013
# Author: Marcus Schmidt
#
#######################################################################################


# requirements
require "rubygems"
require "fileutils"
# setup connection to relevant tables in mayo
require "/Volumes/vgraid/mr_data/scripts/lib/mayo_db.rb"
# load fmri_preproc library
require "/Volumes/vgraid/mr_data/scripts/lib/fmri_preproc.rb"

if ARGV.length < 1
  puts " "
  puts " You must provide at least one event_id."
  puts " Example: ./knicr_pipeline.rb 100123"
  puts " "
  puts " Note: You can include multiple event_ids, just separate each one with a space."
  puts " Example: ./knicr_pipeline.rb 100123 100136 101458"
  puts " "
  exit
end



ARGV.each do |event_id|
  r_number = Event.find(event_id).enrollment.subject.generation_r

  study = Event.find(event_id).enrollment.study.shortname

  puts " "
  puts "######################################"
  puts "# Subject:             #{r_number}"
  puts "# Event:               #{event_id}"
  puts "# Registered study:    #{study}"
  puts "######################################"
  
  d = ["/Volumes/vgraid/mr_data/dicom",study,r_number,event_id.to_s]
  dcm_dir = d.join("/")
  
  # check if subject has a dicom dir for given event and study
  if !File.exist?(dcm_dir)
    # if it does not, check if a correctly named one exists received_dicom
    s = [study,r_number,event_id.to_s]
    subject_rcv_dir = s.join("_")
    r = ["/Volumes/vgraid/mr_data/received_dicom",subject_rcv_dir]
    rcv_dir = r.join("/")
    if File.exist?(rcv_dir)
      # check if subject has a dicom directory (no matching event dir though)
      sd = ["/Volumes/vgraid/mr_data/dicom",study,r_number]
      subject_dcm_dir = sd.join("/")
      if !File.exist?(subject_dcm_dir)
        FileUtils.mkdir subject_dcm_dir
      end
      # move subject's directory from received_dicom to their directory in dicom
      FileUtils.mv(rcv_dir, dcm_dir)
    end
  end

  system("/Volumes/vgraid/mr_data/scripts/dcm2nii.sh #{r_number} #{event_id} 't1' #{study}")

  system("/Volumes/vgraid/mr_data/scripts/dcm2nii.sh #{r_number} #{event_id} 'pd' #{study}")

  system("/Volumes/vgraid/mr_data/scripts/dcm2nii.sh #{r_number} #{event_id} 'dti' #{study}")

  # preprocess resting state fMRI
  fmri_basic_preproc(event_id,5)

  # make sure proper permissions and group ownership are set
  system("chmod -Rf 775 /Volumes/vgraid/mr_data/nii/#{study}/#{r_number}")
  system("chown -Rf :mrdatausers /Volumes/vgraid/mr_data/nii/#{study}/#{r_number}")

  system("/Volumes/vgraid/mr_data/scripts/error_chk_knicr.sh #{r_number} #{event_id} #{study}")

  begin
    FileUtils.chmod_R 0550, "/Volumes/vgraid/mr_data/dicom/#{study}/#{r_number}"
  rescue
    puts " "
  end

end
