class Enrollment < ActiveRecord::Base
  belongs_to :subject
  belongs_to :study_group
  belongs_to :study
  has_many :events
  has_many :initial_scan_qualities, :through => :events
  
  def to_label
    "Subject #{subject_id} (Study #{study_id})"
  end
end
