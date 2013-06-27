class Study < ActiveRecord::Base
  belongs_to :user
  has_many :enrollments
  has_many :subjects, :through => :enrollments
  has_many :events, :through => :enrollments
  has_many :study_procedures
  has_many :procedures, :through => :study_procedures
  has_many :initial_scan_qualities, :through => :events

  def to_label
    "#{id} - #{title}"
  end
end
