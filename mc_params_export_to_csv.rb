#!/usr/bin/env ruby

#######################################################################################
# This script exports mc_params calculations to a CSV file
#
# Created: 13-02-2013
# Edited: 
# Author: Marcus Schmidt
#
#######################################################################################

# for irb
# load '/Volumes/vgraid/mr_data/scripts/mc_params/mc_params_export_to_csv.rb'

# call requirements
require "rubygems"
require "active_record"
require "mysql"
require 'csv'
#require 'etc'

# setup connection to relevant tables in mayo
load "/Volumes/vgraid/mr_data/scripts/lib/mayo_db.rb"

def check_usage
  unless ARGV.length == 2
    puts " "
    puts "Usage: mc_params_export_to_csv.rb study_id path/to/output.csv"
    puts " "
    puts "i.e. ./mc_params_export_to_csv.rb 101 ~/output.csv"
    puts " "
    puts "To get all motion parameters, regardless of study, use 'all' (without quotes) as the study_id"
    puts " "
    exit
  end 
end

def export_to_csv(mc_params_array,csv_file)
  # create header of csv file
  header = ["R_number","event_id","study_id","sequence","tr","max_displacment","max_displacement_p2p","max_x","max_y","max_z","mean_displacment","mean_rms","mc_stat_id"]
  CSV.open(csv_file, "wb") do |csv|
    csv << header
    # now add the rest of the data for the csv file
    mc_params_array.each do |row|
      csv << [row.r_number,row.event_id,row.study_name,row.sequence.name,row.sequence.tr_count,row.max_volume_displacement,row.max_volume_displacement_p2p,row.max_ds,row.max_dl,row.max_dp,row.mean_volume_displacement,row.mean_rmsnew,row.id]
    end
  end
end

def get_all_mc_array
  McStat.find(:all)
end

def get_study_specific_mc_array(study_id)
  Study.find(study_id).mc_stats
end

# if script is being run from command line, do the following
if $0 == __FILE__ 
  check_usage
  study_id = ARGV[0]
  csv_file = ARGV[1]
  
  # check if user wants specific study or all studies
  if study_id == "all"
    # get all motion parameters in Mayo
    mc_params_array = get_all_mc_array
  else
    # get motion parameters for the given study
    mc_params_array = get_study_specific_mc_array(study_id)
  end
  
  # export motion parameters to a csv file
  export_to_csv(mc_params_array,csv_file)
end
