class Subject < ActiveRecord::Base
  has_many :enrollments
  has_many :events, :through => :enrollments
  has_many :initial_scan_qualities, :through => :events
  has_many :freesurfer_qualities, :through => :initial_scan_qualities
  has_many :phone_calls
  has_many :studies, :through => :enrollments
  
  validates_presence_of :generation_r, :on => :create, :message => "can't be blank"
  validates_uniqueness_of :generation_r, :on => :create, :message => "must be unique"
  #validates_length_of :generation_r, :within => 7, :on => :create, :message => "must be 7 characters long"
  
  def to_label
    "#{id} - #{generation_r}"
  end
  
  # create virtual column for call count
  def call_count
    self.phone_calls.count
  end
end
