#######################################################################################
# This script is used to mark the corresponding event in the DB as transferred
#
# Date Created: 12/05/2012
# Last Edited:  20/06/2013
# Author: Marcus Schmidt
#
#######################################################################################


# call requirements
require 'rubygems'
require 'active_record'
require 'fileutils'

# setup connection to relevant tables in mayo
require '/Volumes/vgraid/mr_data/scripts/lib/mayo_db.rb'
  
# CLASS CREATION
class Subject < ActiveRecord::Base
  has_many :enrollments
  has_many :events, :through => :enrollments
end

class Study < ActiveRecord::Base
  has_many :enrollments
end

class Enrollment < ActiveRecord::Base
  belongs_to :subject
  belongs_to :study
  has_many :events
end

class Event < ActiveRecord::Base
  belongs_to :enrollment
  has_many :initial_scan_qualities
end

class InitialScanQuality < ActiveRecord::Base
  belongs_to :event
end

def acquisitions_recorded(event_id)
  Event.find(event_id).initial_scan_qualities
end

def acquisition_received(acquisition_id)
  # get regexp for acquisition directory
  dir_prefix = InitialScanQuality.find(acquisition_id).sequence.dir_prefix
  # get minimum number of dicoms required for full reconstruction
  min_dcm = InitialScanQuality.find(acquisition_id).sequence.min_dcm
  # add an asterisk to the of the variable dir_prefix
  aa = dir_prefix + "*"
  # create array of all directories that match the pattern in the variable aa
  acquisition_directories = Dir.glob(aa)
  # iterate through acquisition_directories, dropping any values (directories) that have less than the minimum dicom needed (given as min_dcm)
  acquisition_directories.keep_if {|c|
    bb = File.join(c, "*.dcm")
    Dir.glob(bb).length >= min_dcm
  }
  if acquisition_directories.length >= 1
    return true
  else
    return false
  end
end

def record_acquisition_status(acquisition_id)
  acquisition = InitialScanQuality.find(acquisition_id)
  if acquisition_received(acquisition_id) == true
    # if true mark as received
    acquisition.received = 1
  else
    # if false mark as not received
    acquisition.received = 0
  end
  acquisition.save
end


# -- Calling of script itself -- #

# execute the following if the file is being called as a script from the command line
if $0 == __FILE__ 
  begin
    # if script is running from command line, do the following
    check_usage
    event_id = ARGV[0]
    # get list of acquisitions registered in mayo
    acquisitions_in_db = acquisitions_recorded(event_id)
    # determine if each was received and save result to mayo
    acquisitions_in_db.each{|a|
      record_acquisition_status(a)
    }
  rescue Exception => ex
    puts ex.message
  end
end
