class FreesurferQuality < ActiveRecord::Base
  belongs_to :initial_scan_quality
  belongs_to :user
  
  def r_number
    begin
      "#{self.initial_scan_quality.event.enrollment.subject.generation_r}"
    rescue
      "N/A"
    end
  end
end
