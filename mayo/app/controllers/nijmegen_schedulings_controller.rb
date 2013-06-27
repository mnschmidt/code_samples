class NijmegenSchedulingsController < ApplicationController
  layout "standard"
  active_scaffold :subject do |config|
    config.theme = :blue
    config.label = "Nijmegen scheduling"
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
    study = 102
    # get all the subjects
    subjects = []
    #Subject.find(:all).each {|s| subjects << s.id }
    Study.find(study).subjects.each {|s| subjects << s.id }
    # get all the enrollments
    subjects_newest_events = Event.find_by_sql("SELECT f.id FROM (SELECT enrollment_id, max(id) AS newest FROM events GROUP BY enrollment_id) AS x INNER JOIN events as f on f.id = x.newest")
    
    # SCHEDULED SUBJECTS
    # get list of event_ids that are already scheduled
    scheduled_events = []
    Event.find(:all, :conditions => ["event_status < 2"]).each {|g| scheduled_events << g.id}
    # get enrollment for each scheduled_event
    scheduled_enrollments = []
    Event.find(scheduled_events).each {|r| scheduled_enrollments << r.enrollment_id }
    # get subject for each scheduled_enrollment
    scheduled_subjects = []
    Enrollment.find(scheduled_enrollments).each {|s| scheduled_subjects << s.subject_id }
    
    # COMPLETED SUBJECTS
    # get list of event_ids that are complete
    completed_events = []
    Event.find(:all, :conditions => ["event_status > 5 AND event_status < 8"]).each {|c| completed_events << c.id}
    # get enrollment for each completed_event
    completed_enrollments = []
    Event.find(completed_events).each {|r| completed_enrollments << r.enrollment_id }
    # get subject for each completed_enrollment
    completed_subjects = []
    Enrollment.find(completed_enrollments).each {|s| completed_subjects << s.subject_id }

    # UNWILLING SUBJECTS
    # get list of event_ids that are unwilling
    unwilling_events = []
    Event.find(:all, :conditions => ["event_status > 3 AND event_status < 6"]).each {|c| unwilling_events << c.id}
    # get enrollment for each unwilling_event
    unwilling_enrollments = []
    Event.find(unwilling_events).each {|r| unwilling_enrollments << r.enrollment_id }
    # get subject for each unwilling_enrollment
    unwilling_subjects = []
    Enrollment.find(unwilling_enrollments).each {|s| unwilling_subjects << s.subject_id }
    
    # EXCLUDE OTHER STUDIES
    # get list of subjects to exclude
    neo_subjects = []
    Study.find_by_id(101).enrollments.each {|y| neo_subjects << y.subject_id}
    grp_subjects = []
    Study.find_by_id(100).enrollments.each {|y| grp_subjects << y.subject_id}
    att_subjects = []
    Study.find_by_id(103).enrollments.each {|y| att_subjects << y.subject_id}
    # get all the phone calls with a result of 2 or 3
    no_calls = []
    PhoneCall.find(:all, :conditions => ["result = 2 OR result = 3 OR result = 6"]).each {|c| no_calls << c.subject_id }
    # potential subjects = subjects that aren't scheduled and haven't refused participation
    @potential_subjects = subjects - scheduled_subjects - completed_subjects - unwilling_subjects - neo_subjects - grp_subjects - att_subjects - no_calls
    #@condition = ['id IN (?)', ['152', '169']]
    @condition = ['subjects.id IN (?)', @potential_subjects]
  end
end 