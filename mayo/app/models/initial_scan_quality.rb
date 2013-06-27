class InitialScanQuality < ActiveRecord::Base
  belongs_to :event
  belongs_to :sequence
  belongs_to :user
  belongs_to :subject
  has_many :freesurfer_qualities
  
  def to_label
    "#{sequence.name} - #{rating}"
  end
  
  def r_number
    begin
      "#{self.event.enrollment.subject.generation_r}"
    rescue
      "N/A"
    end
  end
end
