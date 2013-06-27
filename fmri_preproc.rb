#!/usr/bin/env ruby

#######################################################################################
# This script is generally meant to be loaded, so that it's methods may be used for 
# preprocessing fMRI data.
#
# Date Created: 25/05/2012
# Last Edited: 26/10/2012
# Author: Marcus Schmidt
#
#######################################################################################

#######################################################################################
#
# NOTE: This script relies on a database and file system for almost every determined
#       parameter. The one exception is the get_slices_per_volume method (found below).
#       The get_slices_per_volume method uses a case statement which must be edited
#       when a sequence is added or removed.
#
#######################################################################################


# load '/Volumes/vgraid/mr_data/scripts/lib/fmri_preproc.rb'

#require 'base64rubygems'
require 'rubygems'
require 'fileutils'
#require 'dicom'

# setup connection to relevant tables in mayo
require '/Volumes/vgraid/mr_data/scripts/lib/mayo_db.rb'

# sequences as of 25 may 2012
# :id => 1, :name => 'IR-FSPGR'
# :id => 2, :name => 'Ax DTI-35dir'
# :id => 4, :name => 'Ax PD FSE'
# :id => 5, :name => 'RestingState - 160 Volumes'
# :id => 6, :name => 'RestingState - 250 Volumes'
# :id => 7, :name => '3DSPGR'
# :id => 8, :name => 'Pain stimuli run 1 - 182 Volumes'
# :id => 9, :name => 'Pain stimuli run 2 - 182 Volumes'
# :id => 10, :name => 'Hariri-A'
# :id => 11, :name => 'Hariri-B'
# :id => 12, :name => 'Set-shifting'

def check_usage
  unless ARGV.length == 2
    puts " "
    puts "Usage: fmri_preproc.rb event_id sequence_id"
    puts " "
    list_sequences
    puts " "
    
  end 
end

def dcm2nii(event_id,sequence_id,output_img_type = "nii.gz",set_perms = 0775)
  if verify_input_directory(event_id,sequence_id)
    input_dir = get_input_directory(event_id,sequence_id)
    prefix = get_nifti_file_prefix(event_id,sequence_id)
    r_number = get_subject(event_id)
    
    output_dir = get_nifti_directory(event_id)
    output_name = prefix + "_" + r_number + "_" + event_id.to_s
    output_file = output_name + "." + output_img_type
    
    # unless output nifti directory already exists, create it
    unless Dir.exist?(output_dir)
      FileUtils.mkdir_p(output_dir)
      # ensure everyone in the group has full R+W permission
      File.chmod(set_perms,output_dir)
    end
    
    # change to nifti directory
    Dir.chdir(output_dir)
    
    # set fullpath of output file by joining output_dir and output_file, using a / as a separator
    fp_out = [output_dir,output_file].join("/")
    
    # unless the subject already has a raw nifti file, make one
    unless File.exist?(fp_out)
      # notify the user of the afni command we're running and then run it
      afni_dcm2nii = "to3d -prefix #{output_file} -save_outliers #{output_txt} -time:zt #{slices_per_volume} #{tr_count} 2000 alt+z '#{input_dir}/*.dcm'"
      puts " "
      puts afni_dcm2nii
      system(afni_dcm2nii)
      # ensure everyone in the group has full R+W permission
      File.chmod(set_perms,output_file,output_txt)
    end
  else
    puts "Unable to find dicom data for the following: #{Sequence.find(sequence_id).name}"
  end
end

def fmri_basic_preproc(event_id,sequence_id)
  if verify_input_directory(event_id,sequence_id) == true
    dcm2nii_fmri(event_id,sequence_id)
    time_shifting(event_id,sequence_id)
    motion_correction(event_id,sequence_id)
  end
end

def get_min_req_slices(sequence_id)
  Sequence.find(sequence_id).min_dcm
end

def get_directory_prefix(sequence_id)
  Sequence.find(sequence_id).dir_prefix
end

def get_nifti_file_prefix(event_id,sequence_id)
  # the following line has been commented out as it doesn't allow us to use both rs-160 and rs-250 without calling two preprocessing jobs.
  # Sequence.find(sequence_id).file_prefix
  input_dir = get_input_directory(event_id,sequence_id)
  # if sequence is resting state, use volume count to build prefix
  if sequence_id == 5 || sequence_id == 6
    volumes = get_tr_count(input_dir)
    nii_prefix = "rs-#{volumes}"
  # otherwise use the standard database lookup
  else
    nii_prefix = Sequence.find(sequence_id).file_prefix
  end
  return nii_prefix
end

def verify_input_directory(event_id,sequence_id) # the following simply returns true or false
  sequence_name = Sequence.find(sequence_id).name
  dir_prefix = Sequence.find(sequence_id).dir_prefix
  min_dcm = Sequence.find(sequence_id).min_dcm
  subject = get_subject(event_id)
  
  b = ["/Volumes/vgraid/mr_data/dicom",get_study_prefix(event_id),subject,event_id.to_s]
  base_dir = b.join("/")
  
  # change to input directory
  Dir.chdir(base_dir)
  
  # add an asterisk to the of the variable dir_prefix
  aa = dir_prefix + "*"
  # create array of all directories that match the pattern in the variable aa
  dcm_dirs = Dir.glob(aa)
  # iterate through dcm_dirs, dropping any values (directories) that have less than the minimum dicom needed (given as min_dcm)
  dcm_dirs.keep_if {|c|
    bb = File.join(c, "*.dcm")
    Dir.glob(bb).length >= min_dcm
  }
  # if more than one 
  if dcm_dirs.length == 1
    return true
  elsif dcm_dirs.length > 1
    return false
    puts " "
    puts "Mutliple #{sequence_name} directories exist. You must first add a '_' to the beginning of the one(s) you don't want to use for preprocessing."
    puts " "
  else
    return false
    puts " "
    puts "No #{sequence_name} directory could be found for subject #{subject}, event_id #{event_id}."
    puts "I looked here: #{base_dir}"
    puts " "
  end
end

def get_input_directory(event_id,sequence_id)
  sequence_name = Sequence.find(sequence_id).name
  dir_prefix = Sequence.find(sequence_id).dir_prefix
  min_dcm = Sequence.find(sequence_id).min_dcm
  subject = get_subject(event_id)
  study_prefix = get_study_prefix(event_id)
  
  b = ["/Volumes/vgraid/mr_data/dicom",study_prefix,subject,event_id.to_s]
  base_dir = b.join("/")
  
  # change to input directory
  Dir.chdir(base_dir)
  
  # add an asterisk to the of the variable dir_prefix
  aa = dir_prefix + "*"
  # create array of all directories that match the pattern in the variable aa
  dcm_dirs = Dir.glob(aa)
  # iterate through dcm_dirs, dropping any values (directories) that have less than the minimum dicom needed (given as min_dcm)
  dcm_dirs.keep_if {|c|
    bb = File.join(c, "*.dcm")
    Dir.glob(bb).length >= min_dcm
  }
  # if more than one 
  if dcm_dirs.length != 1
    if dcm_dirs.length > 1
      raise "Error: There is more than one #{sequence_name} directory for subject #{subject}, event #{event_id}"
    elsif dcm_dirs.length < 1
      raise "*** Warning: No #{sequence_name} directory for subject #{subject}, event #{event_id}, study #{study_prefix} ***"
    end
  end
  x = ["/Volumes/vgraid/mr_data/dicom",get_study_prefix(event_id),subject,event_id.to_s,dcm_dirs[0].to_s]
  input_dir = x.join("/")
  #input_dir = "/Volumes/vgraid/mr_data/dicom/" +  get_study_prefix(event_id) + "/" + subject + "/" + event_id.to_s + "/" + dcm_dirs.to_s
  return input_dir
end

def get_nifti_directory(event_id)
  x = ["/Volumes/vgraid/mr_data/nii",get_study_prefix(event_id),get_subject(event_id),event_id.to_s]
  nii_dir = x.join("/")
  
  if !nii_dir.nil?
    return nii_dir
  else
    raise "Error: Could not find nii_dir: #{nii_dir}"
  end
end

def get_study_prefix(event_id)
  Event.find(event_id).enrollment.study.shortname
end

def get_subject(event_id)
  Event.find(event_id).enrollment.subject.generation_r
end

def get_total_slices(input_dir)
  # append "*.dcm" so we count all (and only) dicom files within input_dir
  dicoms = File.join(input_dir, "*.dcm")
  # get total number of dicom files found in input_dir
  total_slices = Dir.glob(dicoms).length
  
  return total_slices
end

def get_slices_per_volume(input_dir)
  total_slices = get_total_slices(input_dir)
  # use total number of dicom files found to determine if there's a known matching slices_per_volume
  slices_per_volume = case total_slices
    when 3315 then 39 # hariri
    when 5920 then 37 # resting state
    when 6279 then 39 # set-shifting
    when 6734 then 37 # pijn
    when 8362 then 37 # hondentaak
    when 9250 then 37 # resting state
    when 6080 then 38 # resting state
    when 6916 then 38 # pijn
    when 9500 then 38 # resting state
    when 6240 then 39 # resting state
    when 7098 then 39 # pijn
    when 7449 then 39 # hondentaak
    when 7488 then 39 # hondentaak
    when 9750 then 39 # resting state 
    else
      raise "slices_per_volume error: Slices per volume could not be calculated. There are likely duplicate files in the dicom pain folder for run , R-number , event_id ."
  end
  
  return slices_per_volume
end

def get_tr_count(input_dir)
  begin
    slices = get_total_slices(input_dir)
    slices_per_volume = get_slices_per_volume(input_dir)
    tr_count = slices / slices_per_volume
  
    return tr_count
  rescue Exception => ex
    puts ex.message
  end
end

def data_match(input_dir,event_id)
  # append "*.dcm" so we count all (and only) dicom files within input_dir
  dicoms = File.join(input_dir, "*.dcm")
  # get first dicom found in input_dir
  first_dicom = Dir.glob(dicoms).first
  dcm = DICOM::DObject.read(first_dicom)
  patient_name_field = dcm.value("0010,0010")
  
  # preserve only last name
  patient_name = patient_name_field.split('^')
  # r number found in the dicom header
  r_number_embedded = patient_name.last
  # r number found in mayo
  r_number_expected = get_subject(event_id)
  
  # notify if r number in dicom header doesn't match r number in mayo
  if r_number_embedded != r_number_expected
    return false
    puts "*** Mismatch detected ***"
    puts "  R number in dicom header: #{r_number_embedded}"
    puts "                   in Mayo: #{r_number_expected}"
  else
    return true
  end
end

def dcm2nii_fmri(event_id,sequence_id,output_img_type = "nii.gz",set_perms = 0775)
  # verify input directory exists
  if verify_input_directory(event_id,sequence_id)
    input_dir = get_input_directory(event_id,sequence_id)
  
    prefix = get_nifti_file_prefix(event_id,sequence_id)
    slices_per_volume = get_slices_per_volume(input_dir)
    tr_count = get_tr_count(input_dir)
  
    r_number = get_subject(event_id)
    
    output_dir = get_nifti_directory(event_id)
    output_name = prefix + "_" + r_number + "_" + event_id.to_s
    output_file = output_name + "." + output_img_type
    output_txt = output_name + "_outliers.txt"
    
    # unless output nifti directory already exists, create it
    unless Dir.exist?(output_dir)
      FileUtils.mkdir_p(output_dir)
      # ensure everyone in the group has full R+W permission
      File.chmod(set_perms,output_dir)
    end
    
    # change to nifti directory
    Dir.chdir(output_dir)
    
    # set fullpath of output file by joining output_dir and output_file, using a / as a separator
    fp_out = [output_dir,output_file].join("/")
    
    # unless the subject already has a raw nifti file, make one
    unless File.exist?(fp_out)
      # notify the user of the afni command we're running and then run it
      puts " "
      puts "to3d -prefix #{output_file} -save_outliers #{output_txt} -time:zt #{slices_per_volume} #{tr_count} 2000 alt+z '#{input_dir}/*.dcm'"
      system("to3d -prefix #{output_file} -save_outliers #{output_txt} -time:zt #{slices_per_volume} #{tr_count} 2000 alt+z '#{input_dir}/*.dcm'")
      # ensure everyone in the group has full R+W permission
      File.chmod(set_perms, output_file,output_txt)
    end
  else
    puts "Unable to find dicom data for the following: #{Sequence.find(sequence_id).name}"
  end
end

def time_shifting(event_id,sequence_id,img_type = "nii.gz",set_perms = 0775)
  output_dir = get_nifti_directory(event_id)
  r_number = get_subject(event_id)
  prefix = get_nifti_file_prefix(event_id,sequence_id)
  
  # skip if time shifted-motion corrected version exists
  mc_img = prefix + "_tsmc_" + r_number + "_" + event_id.to_s + "." + img_type
  mc_img_fullpath = output_dir + "/" + mc_img
  unless File.exist?(mc_img_fullpath)
    input_file = prefix + "_" + r_number + "_" + event_id.to_s + "." + img_type
    output_file = prefix + "_ts_" + r_number + "_" + event_id.to_s + "." + img_type
  
    # change to nifti directory
    Dir.chdir(output_dir)
  
    # check to make sure input file exists
    if File.exist?(input_file)
      # continue if output file does NOT exist
      unless File.exist?(output_file)
        # time shifting
        ts = "3dTshift -ignore 4 -prefix #{output_file} #{input_file}"
        puts ' '
        puts ts
        system(ts)
        File.chmod(set_perms, output_file)
        # reorientation
        reorient = "fslreorient2std #{output_file} #{output_file}"
        puts ' '
        puts reorient
        system(reorient)
      end
    else
      puts "Input not found for time shifting correction. Consider running dcm2nii conversion first."
    end
  end
end

def motion_correction(event_id,sequence_id,img_type = "nii.gz",set_perms = 0775)
  nii_dir = get_nifti_directory(event_id)
  r_number = get_subject(event_id)
  prefix = get_nifti_file_prefix(event_id,sequence_id)
  
  input_file = prefix + "_ts_" + r_number + "_" + event_id.to_s + "." + img_type
  output_file = prefix + "_tsmc_" + r_number + "_" + event_id.to_s + "." + img_type
  mc_params_file = prefix + "_tsmc_" + r_number + "_" + event_id.to_s + "_mc_params.txt"
  
  # change to nifti directory
  Dir.chdir(get_nifti_directory(event_id))
  
  if File.exist?(input_file)
    unless File.exist?(output_file)
      mc = "3dvolreg -prefix #{output_file} -base 1 -zpad 4 -twopass -twodup -Fourier -dfile #{mc_params_file} #{input_file}"
      puts " "
      puts mc
      system(mc)
      File.chmod(set_perms, output_file,mc_params_file)
      mc_duplicate = '/Volumes/vgraid/mr_data/lists/mc_params/np-#{trs}_r#{run}_tsmc_#{genr}_#{eventid}_out.txt'
      if File.exist?(mc_duplicate)
        File.delete(mc_duplicate)
      end
      FileUtils.cp(mc_params_file,'/Volumes/vgraid/mr_data/lists/mc_params/')
      # get rid of time_shifted version once we have the time_shifted,motion_correction version
      File.delete(input_file)
      # get volume count of nii file
      volumes = %x{wc -l #{mc_params_file}}.split.first.to_i
      # add mc_params to mayo
      system("/Volumes/vgraid/mr_data/scripts/lib/mc_params/mc_params2mayo.rb #{event_id} #{sequence_id} #{volumes} #{mc_params_file}")
    end
  end
end

def list_sequences
  sequences = Sequence.find(:all)

  printf "%-#{3}s %-#{15}s %s\n", "id", "file_prefix", "sequence_name"
  sequences.each do |i|
    printf "%-#{3}s %-#{15}s %s\n", i.id, i.file_prefix, i.name
  end
end


# -- Calling of script itself -- #

# execute the following if the file is being called as a script from the command line
if $0 == __FILE__ 
  begin
    # if script is running from command line, do the following
    check_usage
    event_id = ARGV[0]
    sequence_id = ARGV[1]

    dcm2nii_fmri(event_id,sequence_id)
    time_shifting(event_id,sequence_id)
    motion_correction(event_id,sequence_id)
  rescue Exception => ex
    puts ex.message
  end
end
