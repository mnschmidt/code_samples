class AttSchedulingsController < ApplicationController
  layout "standard"
  active_scaffold :subject do |config|
    config.theme = :blue
    config.label = "ATT scheduling"
    config.list.columns = [:generation_r, :first_name, :last_name, :date_of_birth, :sex, :call_count]
    config.create.columns = [:generation_r, :first_name, :last_name, :date_of_birth, :sex, :email, :address, :house_number, :house_number_toev, :post_code, :city, :phone, :mobile, :research_status, :date_letter_sent, :note]
    config.update.columns = [:generation_r, :first_name, :last_name, :date_of_birth, :sex, :email, :address, :house_number, :house_number_toev, :post_code, :city, :phone, :mobile, :research_status, :date_letter_sent, :note]
    #config.columns.add :call_count
    config.columns[:generation_r].label = "R number"
    config.columns[:sex].form_ui = :select
    config.columns[:sex].options = {:options => [[' - select - ',nil],['Female',0],['Male',1],['Other',2]]}
    config.nested.add_link :phone_calls
    config.nested.add_link :enrollments
    #config.nested.add_link "Events", [:events]
    config.list.per_page = 250
  end
  
  def before_create_save(record)
    @record.created_by = @login
  end
  
  def before_update_save(record)
    @record.updated_by = @login
  end
  
  def conditions_for_collection
    study = 103
    # get all the subjects
    subjects = []
    #Subject.find(:all).each {|s| subjects << s.id }
    Study.find(study).subjects.each {|s| subjects << s.id }
    # get all the enrollments
    subjects_newest_events = Event.find_by_sql("SELECT f.id FROM (SELECT enrollment_id, max(id) AS newest FROM events GROUP BY enrollment_id) AS x INNER JOIN events as f on f.id = x.newest")
    #bad_events = Event.find(:all, :conditions => ["event_status = 2 OR event_status = 3"])
    good_events = []
    Event.find(:all, :conditions => ["event_status < 2 OR event_status > 3"]).each {|g| good_events << g.id}
    #reschedules = bad_events & subjects_newest_events
    #reschedule_ids = []
    scheduled_enrollment_ids = []
    Event.find(good_events).each {|r| scheduled_enrollment_ids << r.enrollment_id }
    # get all enrollments
    all_enrollments = []
    Enrollment.find(scheduled_enrollment_ids).each {|s| all_enrollments << s.subject_id }
    # get list of nijmegen enrollments
    study_enrollments = []
    Study.find(study).enrollments.each {|y| study_enrollments << y.subject_id}
    # filter out non-nijmegen enrollments
    scheduled_subjects = study_enrollments & all_enrollments
    # get all the phone calls with a result of 2 or 3
    no_calls = []
    PhoneCall.find(:all, :conditions => ["result = 2 OR result = 3 OR result = 6"]).each {|c| no_calls << c.subject_id }
    # potential subjects = subjects that aren't scheduled and haven't refused participation
    @potential_subjects = subjects - scheduled_subjects - no_calls
    #@condition = ['id IN (?)', ['152', '169']]
    @condition = ['subjects.id IN (?)', @potential_subjects]
  end
end 