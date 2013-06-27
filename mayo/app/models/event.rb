class Event < ActiveRecord::Base
  belongs_to :enrollment
  belongs_to :subject
  belongs_to :procedure
  has_many :initial_scan_qualities
  #has_many :preprocess_jobs
  
  #validates_presence_of :study_procedure
  validates_presence_of :event_status
  validates_presence_of :procedure_id
  validates_presence_of :event_start_time
  validates_uniqueness_of :event_start_time, :scope => :event_status
  
  # PRE-ARRIVAL
    # Refused = 1
    # No show = 2
    # Canceled = 3
  # POST-ARRIVAL
    # Unwilling child = 4
    # Unwilling parent = 5
  # COMPLETED
    # Partially successful = 6
    # Completely successful = 7
  
  def to_label
    "#{id}"
  end
  
  def r_number
    begin
      "#{self.enrollment.subject.generation_r}"
    rescue
      "N/A"
    end
  end
  
  def subject_name
      "#{self.enrollment.subject.first_name} #{self.enrollment.subject.last_name}"
  end
  
  def date_of_birth
      "#{self.enrollment.subject.date_of_birth}"
  end
  
  def nepsy_start
    # if doing a nepsy, mock and mri, the nepsy starts at event_start_time
    if self.procedure.id == 8
      "#{self.event_start_time.to_formatted_s(:time)}"
    # if doing only a nepsy, start at event_start_time
    elsif self.procedure.id == 3 || 4
      "#{self.event_start_time.to_formatted_s(:time)}"
    # else there is no mri scheduled
    else
      "---"
    end
  end
  
  def mock_start
    # if doing a nepsy, mock and mri, the mock starts 70 min after event_start_time
    if self.procedure.id == 8
    "#{self.event_start_time.ago(-4200).strftime("%H:%M")}"
    # if doing a mock and mri, the mock starts 30 min after event_start_time
    elsif self.procedure.id == 2
      "#{self.event_start_time.strftime("%H:%M")}"
    # else there is no mock scheduled
    else
      "---"
    end
  end
  
  def mri_start
    # if doing a nepsy, mock and mri, the mri starts 115 min after event_start_time
    if self.procedure.id == 8
      "#{self.event_start_time.ago(-6900).strftime("%H:%M")}"
    # if doing a mock and mri, the mri starts 30 min after event_start_time
    elsif self.procedure.id == 2
      "#{self.event_start_time.ago(-1800).strftime("%H:%M")}"
    # if doing an mri, the mri starts at event_start_time
    elsif self.procedure.id == 1
      "#{self.event_start_time.strftime("%H:%M")}"
    # else there is no mri scheduled
    else
      "---"
    end
  end
end
