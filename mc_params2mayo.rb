#!/usr/bin/env ruby

#######################################################################################
# This script imports a CSV file of motion parameters into the mayo database
#
# Created: 03/04/2012
# Edited: 30/10/2012
# Author: Marcus Schmidt
#
#######################################################################################

# for irb
# load '/Volumes/vgraid/mr_data/scripts/lib/mc_params2mayo.rb'

# -- Configuration for script-- #

# call requirements
require "rubygems"
require "active_record"
require "mysql"
require 'csv'
require 'etc'

# setup connection to relevant tables in mayo
require "/Volumes/vgraid/mr_data/scripts/lib/mayo_db.rb"

# METHODS
def init(event_id)
  @event = Event.find(event_id)
  
  
  
  #roll = Array.new
  #pitch = Array.new
  #yaw = Array.new
  #dS = Array.new
  #dL = Array.new
  #dP = Array.new
  #rmsold = Array.new
  #rmsnew = Array.new
  #
  #roll_d = Array.new
  #pitch_d = Array.new
  #yaw_d = Array.new
  #dS_d = Array.new
  #dL_d = Array.new
  #dP_d = Array.new
  #rmsold_d = Array.new
  #rmsnew_d = Array.new
  #
  #mean_roll = Array.new
  #mean_pitch = Array.new
  #mean_yaw = Array.new
  #mean_dS = Array.new
  #mean_dL = Array.new
  #mean_dP = Array.new
  #mean_rmsold = Array.new
  #mean_rmsnew = Array.new
end

def get_current_user
  @user = Etc.getlogin
  @current_user = User.find_by_login(@user)
end

def chk
  path = '/Volumes/vgraid/mr_data/nii/' + Event.study(@event) + '/' + Event.r_number(@event) + '/' + @event.id.to_s + '/'
  csv_file = 'rs-' + @trs.to_s + '_tsmc_' + Event.r_number(@event) + '_' + @event.id.to_s + '_out.txt'
  mc_params_file = path + csv_file
  @array = Array.new
  CSV.foreach(mc_params_file, :col_sep => "\s", :converters => :all) do |row|
    # append 'row' to 'array'
    @array.push(row)
  end
  @mcParams = @array.transpose
  @roll = @mcParams[1]
end

def import(event_id,csv_file)
  @event = Event.find(event_id)
  
  path = '/Volumes/vgraid/mr_data/nii/' + Event.study(@event) + '/' + Event.r_number(@event) + '/' + @event.id.to_s + '/'
  
  # concatenate path + csv_file for vargin
  mc_params_file = path + csv_file
  
  # make sure mc_params_file exists
  #file_exists(mc_params_file)
  
  # create a new array named 'array'
  array = Array.new
  
  # extract data from csv file
  CSV.foreach(mc_params_file, :col_sep => "\s", :converters => :all) do |row|
    # append 'row' to 'array'
    array.push(row)
  end
  # transpose the array so that each dimension (column) is it's own row
  @mcParams = array.transpose
  # store each dimension as a variable
  @volumes = @mcParams[0]
  @roll = @mcParams[1]
  @pitch = @mcParams[2]
  @yaw = @mcParams[3]
  @ds = @mcParams[4]
  @dl = @mcParams[5]
  @dp = @mcParams[6]
  @rmsold = @mcParams[7]
  @rmsnew = @mcParams[8]
end

def file_exists(file)
  unless File.exist?(file)
    puts "*Error: No motion correction parameter file found. MC parameters will not be imported into Mayo"
    exit
  end
end

def check_usage
  unless ARGV.length == 4
    puts " "
    puts "Usage: ./mc_params.rb event_id sequence_id trs mc_params_file_name"
    puts " "
    puts "Get a list of sequence_ids using the following command:"
    puts "    ./mc_params.rb list_sequences"
    puts " "
    exit
  end 
end

def derivative(dimension)
  x = Array.new
  for i in 0..dimension.size - 2
    d = dimension[i] - dimension[i+1]
    x.push(d)
  end
  return x
end

def get_displacement_array(motion_params_array)
  dispArray = Array.new
  volumes = motion_params_array[0].count
  
  for volume in 1..volumes - 1
#    x2 = motion_params[4][volume]
#    y2 = motion_params[5][volume]
#    z2 = motion_params[6][volume]
#    x1 = motion_params[4][volume - 1]
#    y1 = motion_params[5][volume - 1]
#    z1 = motion_params[6][volume - 1]
#    
#    xd = x2 - x1
#    yd = y2 - y1
#    zd = z2 - z1

    xd = motion_params_array[4][volume] - motion_params_array[4][volume - 1]
    yd = motion_params_array[5][volume] - motion_params_array[5][volume - 1]
    zd = motion_params_array[6][volume] - motion_params_array[6][volume - 1]
    
    d = Math.sqrt(xd**2 + yd**2 + zd**2)
    dispArray.push(d)
  end
  return dispArray
end

def max(dimension)
  max_dim = dimension.max - dimension.min
  return max_dim
end

def max_displacement
  x_max = @ds.max - @ds.min
  y_max = @dl.max - @dl.min
  z_max = @dp.max - @dp.min
  
  # get the sqrt for the sum of the three squares
  sum_of_sqs = x_max**2 + y_max**2 + z_max**2
  max_displac = Math.sqrt(sum_of_sqs)
  return max_displac
end

def max_displacement_p2p(motion_params_array)
  max_dis_p2p = get_displacement_array(motion_params_array).max
  return max_dis_p2p
end

def mean(dimension)
  meanArray = Array.new
  volumes = dimension.count
  for volume in 1..volumes - 1
    xd = dimension[volume] - dimension[volume - 1]
    rd = xd.abs
    meanArray.push(rd)
  end
  mean_dim = meanArray.inject{|sum, el| sum + el }.to_f / meanArray.size
  return mean_dim
end

def mean_displacement(motion_params_array)
  darr = get_displacement_array(motion_params_array)
  mean_dis = darr.inject{|sum, el| sum + el }.to_f / darr.size
  return mean_dis
end

def rss_max
  unless @mcParams.nil?
    dispArray = Array.new
    volumes = @roll.length
    
    for volume in 0..volumes - 1
      # get the squares of x, y, and z
      x = @ds[volume]**2
      y = @dl[volume]**2
      z = @dp[volume]**2
    
      # get the sum
      a = x + y + z
      # find the root and pass it to @max_rss array
      dispArray[volume] = Math.sqrt(a)
    end
    
    @diffArray = Array.new
    count = 0
    for volume in 1..volumes - 1
      d = dispArray[volume] - dispArray[volume - 1]
      @diffArray.push(d)
      count = count + 1
    end
  end
end

def median(dimension)
  dim_median = (dimension.sort[dimension.size/2] + dimension.sort[(dimension.size+1)/2]) / 2
  return dim_median
end

def create(event_id,sequence_id)
  record = McStat.new
  
  record.event_id       = event_id
  record.sequence_id    = sequence_id
  record.created_by     = @current_user[:id]

  #record.max_volume_displacement = @diffArray.max
  record.max_volume_displacement = max_displacement
  record.max_volume_displacement_p2p = max_displacement_p2p(@mcParams)
  record.mean_volume_displacement = mean_displacement(@mcParams)
  #record.roll           = @roll
  #record.pitch          = @pitch
  #record.yaw            = @yaw
  #record.ds             = @ds
  #record.dl             = @dl
  #record.dp             = @dp
  #record.rmsold         = @rmsold
  #record.rmsnew         = @rmsnew
  #
  #record.roll_d         = derivative(@roll)
  #record.pitch_d        = derivative(@pitch)
  #record.yaw_d          = derivative(@yaw)
  #record.ds_d           = derivative(@ds)
  #record.dl_d           = derivative(@dl)
  #record.dp_d           = derivative(@dp)
  #record.rmsold_d       = derivative(@rmsold)
  #record.rmsnew_d       = derivative(@rmsnew)
  
  record.mean_roll      = mean(@roll)
  record.mean_pitch     = mean(@pitch)
  record.mean_yaw       = mean(@yaw)
  record.mean_ds        = mean(@ds)
  record.mean_dl        = mean(@dl)
  record.mean_dp        = mean(@dp)
  record.mean_rmsold    = mean(@rmsold)
  record.mean_rmsnew    = mean(@rmsnew)
  
  record.max_roll       = max(@roll)
  record.max_pitch      = max(@pitch)
  record.max_yaw        = max(@yaw)
  record.max_ds         = max(@ds)
  record.max_dl         = max(@dl)
  record.max_dp         = max(@dp)
  record.max_rmsold     = max(@rmsold)
  record.max_rmsnew     = max(@rmsnew)
  
  record.median_roll    = median(@roll)
  record.median_pitch   = median(@pitch)
  record.median_yaw     = median(@yaw)
  record.median_ds      = median(@ds)
  record.median_dl      = median(@dl)
  record.median_dp      = median(@dp)
  record.median_rmsold  = median(@rmsold)
  record.median_rmsnew  = median(@rmsnew)

  record.save
end

def update(event_id,sequence_id)
  record = McStat.find_by_event_id_and_sequence_id(event_id,sequence_id)
  
  record.event_id       = event_id
  record.sequence_id    = sequence_id
  record.updated_by     = @current_user[:id]

  #record.max_volume_displacement = @diffArray.max
  record.max_volume_displacement = max_displacement
  record.max_volume_displacement_p2p = max_displacement_p2p(@mcParams)
  record.mean_volume_displacement = mean_displacement(@mcParams)
  #record.roll           = @roll
  #record.pitch          = @pitch
  #record.yaw            = @yaw
  #record.ds             = @ds
  #record.dl             = @dl
  #record.dp             = @dp
  #record.rmsold         = @rmsold
  #record.rmsnew         = @rmsnew
  #
  #record.roll_d         = derivative(@roll)
  #record.pitch_d        = derivative(@pitch)
  #record.yaw_d          = derivative(@yaw)
  #record.ds_d           = derivative(@ds)
  #record.dl_d           = derivative(@dl)
  #record.dp_d           = derivative(@dp)
  #record.rmsold_d       = derivative(@rmsold)
  #record.rmsnew_d       = derivative(@rmsnew)
  
  record.mean_roll      = mean(@roll)
  record.mean_pitch     = mean(@pitch)
  record.mean_yaw       = mean(@yaw)
  record.mean_ds        = mean(@ds)
  record.mean_dl        = mean(@dl)
  record.mean_dp        = mean(@dp)
  record.mean_rmsold    = mean(@rmsold)
  record.mean_rmsnew    = mean(@rmsnew)
  
  record.max_roll       = max(@roll)
  record.max_pitch      = max(@pitch)
  record.max_yaw        = max(@yaw)
  record.max_ds         = max(@ds)
  record.max_dl         = max(@dl)
  record.max_dp         = max(@dp)
  record.max_rmsold     = max(@rmsold)
  record.max_rmsnew     = max(@rmsnew)
  
  record.median_roll    = median(@roll)
  record.median_pitch   = median(@pitch)
  record.median_yaw     = median(@yaw)
  record.median_ds      = median(@ds)
  record.median_dl      = median(@dl)
  record.median_dp      = median(@dp)
  record.median_rmsold  = median(@rmsold)
  record.median_rmsnew  = median(@rmsnew)

  record.save
end

def list_sequences
  puts " "
  sequences = Sequence.find(:all)
  puts "sequence_id => sequence_name"
  sequences.each{|s| 
    puts "#{s.id} => #{s.file_prefix}"
  }
  puts " "
end

# if script is being run from command line, do the following
if $0 == __FILE__ 
  if ARGV[0] == "list_sequences"
    list_sequences
  else
    check_usage
    event_id = ARGV[0]
    sequence_id = ARGV[1]
    @trs = ARGV[2]
    csv_file = ARGV[3]
    get_current_user
    #init(event_id)

    # import csv file containing motion correction parameters
    import(event_id,csv_file)
    # get max displacements per volume
   # rss_max
    motion_params_array = @mcParams

    case McStat.find_by_event_id_and_sequence_id(event_id,sequence_id).nil?
    when true
      create(event_id,sequence_id)
    when false
      update(event_id,sequence_id)
    end
  end
end
