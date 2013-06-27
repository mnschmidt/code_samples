class ReportsController < ApplicationController  
  layout "standard"
  def index
    # example of query of all enrollments that are part of the cannabis group for study 100
    # cannabis_enrollments = []
    # StudyGroup.find(1).enrollments.each {|c| cannabis_enrollments << c.id }
    
    # StudyGroup.names
    # "Cannabis"        = 1
    # "Smokers"         = 2
    # "Antidepressants" = 3
    # "*High folate"    = 4
    # "*Low folate"     = 5
    # "Dysregulation"   = 6
    # "Controls"        = 7
    
    cannabis        = StudyGroup.find(1).enrollments
    smokers         = StudyGroup.find(2).enrollments
    antidepressants = StudyGroup.find(3).enrollments
    high_folates    = StudyGroup.find(4).enrollments
    low_folates     = StudyGroup.find(5).enrollments
    dysregulations  = StudyGroup.find(6).enrollments
    controls        = StudyGroup.find(7).enrollments
    
    # Enrollment.statuses
    # "Active"            = 1
    # "Refused"           = 2
    # "Canceled"          = 3
    # "Unwilling child"   = 4 
    # "Unwilling parent"  = 5
    
    active_enrollments = Enrollment.find(:all, :conditions => "status = 1")
    refused            = Enrollment.find(:all, :conditions => "status = 2")
    no_show            = Event.find(:all, :conditions => "event_status = 2")
    canceled           = Event.find(:all, :conditions => "event_status = 3")
    unwilling_children = Event.find(:all, :conditions => "event_status = 4")
    unwilling_parent   = Event.find(:all, :conditions => "event_status = 5")
    
    # Refused
    cannabis_refused = cannabis & refused
    @cannabis_refused = cannabis_refused.count
    smokers_refused = smokers & refused
    @smokers_refused = smokers_refused.count
    antidepressants_refused = antidepressants & refused
    @antidepressants_refused = antidepressants_refused.count
    high_folates_refused = high_folates & refused
    @high_folates_refused = high_folates_refused.count
    low_folates_refused = low_folates & refused
    @low_folates_refused = low_folates_refused.count
    dysregulations_refused = dysregulations & refused
    @dysregulations_refused = dysregulations.count
    controls_refused = controls & refused
    @controls_refused = controls_refused.count
    #@total_refused = @cannabis_refused + @smokers_refused + @antidepressants_refused + @high_folates_refused + @low_folates_refused + @dysregulations_refused + @controls_refused
    @total_refused = Enrollment.find(:all, :conditions => "status = 2").count
    
    # No shows
    cannabis_no_show = cannabis & no_show
    @cannabis_no_show = cannabis_no_show.count
    smokers_no_show = smokers & no_show
    @smokers_no_show = smokers_no_show.count
    antidepressants_no_show = antidepressants & no_show
    @antidepressants_no_show = antidepressants_no_show.count
    high_folates_no_show = high_folates & no_show
    @high_folates_no_show = high_folates_no_show.count
    low_folates_no_show = low_folates & no_show
    @low_folates_no_show = low_folates_no_show.count
    dysregulations_no_show = dysregulations & no_show
    @dysregulations_no_show = dysregulations.count
    controls_no_show = controls & no_show
    @controls_no_show = controls_no_show.count
    #@total_no_show = @cannabis_no_show + @smokers_no_show + @antidepressants_no_show + @high_folates_no_show + @low_folates_no_show + @dysregulations_no_show + @controls_no_show
    @total_no_show = Event.find(:all, :conditions => "event_status = 2").count
    
    # Canceled
    cannabis_canceled = cannabis & canceled
    @cannabis_canceled = cannabis_canceled.count
    smokers_canceled = smokers & canceled
    @smokers_canceled = smokers_canceled.count
    antidepressants_canceled = antidepressants & canceled
    @antidepressants_canceled = antidepressants_canceled.count
    high_folates_canceled = high_folates & canceled
    @high_folates_canceled = high_folates_canceled.count
    low_folates_canceled = low_folates & canceled
    @low_folates_canceled = low_folates_canceled.count
    dysregulations_canceled = dysregulations & canceled
    @dysregulations_canceled = dysregulations.count
    controls_canceled = controls & canceled
    @controls_canceled = controls_canceled.count
    #@total_canceled = @cannabis_canceled + @smokers_canceled + @antidepressants_canceled + @high_folates_canceled + @low_folates_canceled + @dysregulations_canceled + @controls_canceled
    @total_canceled = Event.find(:all, :conditions => "event_status = 3").count
    
    cannabis_events = []
    StudyGroup.find(1).events.each {|c| cannabis_events << c.id }
    smoker_events = []
    StudyGroup.find(2).events.each {|s| smoker_events << s.id }
    antidepressant_events = []
    StudyGroup.find(3).events.each {|a| antidepressant_events << a.id }
    high_folate_events = []
    StudyGroup.find(4).events.each {|h| high_folate_events << h.id }
    low_folate_events = []
    StudyGroup.find(5).events.each {|l| low_folate_events << l.id }
    dysregulation_events = []
    StudyGroup.find(6).events.each {|d| dysregulation_events << d.id }
    control_events = []
    StudyGroup.find(7).events.each {|e| control_events << e.id }
    
    # Unwilling children
    unwilling_children = []
    Event.find(:all, :conditions => "event_status = 4").each {|c| unwilling_children << c.id }
    cannabis_unwilling_children = unwilling_children & cannabis_events
    @cannabis_unwilling_children = cannabis_unwilling_children.count
    smoker_unwilling_children = unwilling_children & smoker_events
    @smoker_unwilling_children = smoker_unwilling_children.count
    antidepressant_unwilling_children = unwilling_children & antidepressant_events
    @antidepressant_unwilling_children = antidepressant_unwilling_children.count
    high_folate_unwilling_children = unwilling_children & high_folate_events
    @high_folate_unwilling_children = high_folate_unwilling_children.count
    low_folate_unwilling_children = unwilling_children & low_folate_events
    @low_folate_unwilling_children = low_folate_unwilling_children.count
    dysregulation_unwilling_children = unwilling_children & dysregulation_events
    @dysregulation_unwilling_children = dysregulation_unwilling_children.count
    control_unwilling_children = unwilling_children & control_events
    @control_unwilling_children = control_unwilling_children.count
    @total_unwilling_children = Event.find(:all, :conditions => "event_status = 4").count
    
    # Unwilling parents
    unwilling_parents = []
    Event.find(:all, :conditions => "event_status = 5").each {|p| unwilling_parents << p.id }
    cannabis_unwilling_parents = unwilling_parents & cannabis_events
    @cannabis_unwilling_parents = cannabis_unwilling_parents.count
    smoker_unwilling_parents = unwilling_parents & smoker_events
    @smoker_unwilling_parents = smoker_unwilling_parents.count
    antidepressant_unwilling_parents = unwilling_parents & antidepressant_events
    @antidepressant_unwilling_parents = antidepressant_unwilling_parents.count
    high_folate_unwilling_parents = unwilling_parents & high_folate_events
    @high_folate_unwilling_parents = high_folate_unwilling_parents.count
    low_folate_unwilling_parents = unwilling_parents & low_folate_events
    @low_folate_unwilling_parents = low_folate_unwilling_parents.count
    dysregulation_unwilling_parents = unwilling_parents & dysregulation_events
    @dysregulation_unwilling_parents = dysregulation_unwilling_parents.count
    control_unwilling_parents = unwilling_parents & control_events
    @control_unwilling_parents = control_unwilling_parents.count
    @total_unwilling_parents = Event.find(:all, :conditions => "event_status = 5").count
    
    # partially completed scans
    @partially_completed_scans = Event.find(:all, :conditions => ["event_status = 6"]).count
    
    # entirely completed scans
    @successfully_completed_scans = Event.find(:all, :conditions => ["event_status = 7"]).count
    
    # partially + entirely completed scans
    @scans_total = @partially_completed_scans + @successfully_completed_scans
    
    # T1s
    t1s = []
    InitialScanQuality.find(:all, :conditions => "sequence_id = 1").each {|t| t1s << t.event_id }
    cannabis_t1s = t1s & cannabis_events
    @cannabis_t1s = cannabis_t1s.count
    smoker_t1s = t1s & smoker_events
    @smoker_t1s = smoker_t1s.count
    antidepressant_t1s = t1s & antidepressant_events
    @antidepressant_t1s = antidepressant_t1s.count
    high_folate_t1s = t1s & high_folate_events
    @high_folate_t1s = high_folate_t1s.count
    low_folate_t1s = t1s & low_folate_events
    @low_folate_t1s = low_folate_t1s.count
    dysregulation_t1s = t1s & dysregulation_events
    @dysregulation_t1s = dysregulation_t1s.count
    control_t1s = t1s & control_events
    @control_t1s = control_t1s.count
    @total_calc_t1s = @cannabis_t1s + @smoker_t1s + @antidepressant_t1s + @high_folate_t1s + @low_folate_t1s + @dysregulation_t1s + @control_t1s
    @total_t1s = InitialScanQuality.find(:all, :conditions => "sequence_id = 1 AND rating > -1 AND rating < 777").count
    
    # poor T1s
    poor_t1s = []
    InitialScanQuality.find(:all, :conditions => "sequence_id = 1 AND rating < 2").each {|p| poor_t1s << p.event_id }
    cannabis_poor_t1s = poor_t1s & cannabis_events
    @cannabis_poor_t1s = cannabis_poor_t1s.count
    smoker_poor_t1s = poor_t1s & smoker_events
    @smoker_poor_t1s = smoker_poor_t1s.count
    antidepressant_poor_t1s = poor_t1s & antidepressant_events
    @antidepressant_poor_t1s = antidepressant_poor_t1s.count
    high_folate_poor_t1s = poor_t1s & high_folate_events
    @high_folate_poor_t1s = high_folate_poor_t1s.count
    low_folate_poor_t1s = poor_t1s & low_folate_events
    @low_folate_poor_t1s = low_folate_poor_t1s.count
    dysregulation_poor_t1s = poor_t1s & dysregulation_events
    @dysregulation_poor_t1s = dysregulation_poor_t1s.count
    control_poor_t1s = poor_t1s & control_events
    @control_poor_t1s = control_poor_t1s.count
    @total_calc_poor_t1s = @cannabis_poor_t1s + @smoker_poor_t1s + @antidepressant_poor_t1s + @high_folate_poor_t1s + @low_folate_poor_t1s + @dysregulation_poor_t1s + @control_poor_t1s
    @total_poor_t1s = InitialScanQuality.find(:all, :conditions => "sequence_id = 1 AND rating < 2").count
    
    # PDs
    pds = []
    InitialScanQuality.find(:all, :conditions => "sequence_id = 4").each {|p| pds << p.event_id }
    cannabis_pds = pds & cannabis_events
    @cannabis_pds = cannabis_pds.count
    smoker_pds = pds & smoker_events
    @smoker_pds = smoker_pds.count
    antidepressant_pds = pds & antidepressant_events
    @antidepressant_pds = antidepressant_pds.count
    high_folate_pds = pds & high_folate_events
    @high_folate_pds = high_folate_pds.count
    low_folate_pds = pds & low_folate_events
    @low_folate_pds = low_folate_pds.count
    dysregulation_pds = pds & dysregulation_events
    @dysregulation_pds = dysregulation_pds.count
    control_pds = pds & control_events
    @control_pds = control_pds.count
    @total_calc_pds = @cannabis_pds + @smoker_pds + @antidepressant_pds + @high_folate_pds + @low_folate_pds + @dysregulation_pds + @control_pds
    @total_pds = InitialScanQuality.find(:all, :conditions => "sequence_id = 4").count
    
    # poor PDs
    poor_pds = []
    InitialScanQuality.find(:all, :conditions => "sequence_id = 4 AND rating < 2").each {|p| poor_pds << p.event_id }
    cannabis_poor_pds = poor_pds & cannabis_events
    @cannabis_poor_pds = cannabis_poor_pds.count
    smoker_poor_pds = poor_pds & smoker_events
    @smoker_poor_pds = smoker_poor_pds.count
    antidepressant_poor_pds = poor_pds & antidepressant_events
    @antidepressant_poor_pds = antidepressant_poor_pds.count
    high_folate_poor_pds = poor_pds & high_folate_events
    @high_folate_poor_pds = high_folate_poor_pds.count
    low_folate_poor_pds = poor_pds & low_folate_events
    @low_folate_poor_pds = low_folate_poor_pds.count
    dysregulation_poor_pds = poor_pds & dysregulation_events
    @dysregulation_poor_pds = dysregulation_poor_pds.count
    control_poor_pds = poor_pds & control_events
    @control_poor_pds = control_poor_pds.count
    @total_calc_poor_pds = @cannabis_poor_pds + @smoker_poor_pds + @antidepressant_poor_pds + @high_folate_poor_pds + @low_folate_poor_pds + @dysregulation_poor_pds + @control_poor_pds
    @total_poor_pds = InitialScanQuality.find(:all, :conditions => "sequence_id = 4 AND rating < 2").count
    
    # DTIs
    dtis = []
    InitialScanQuality.find(:all, :conditions => "sequence_id = 2").each {|d| dtis << d.event_id }
    cannabis_dtis = dtis & cannabis_events
    @cannabis_dtis = cannabis_dtis.count
    smoker_dtis = dtis & smoker_events
    @smoker_dtis = smoker_dtis.count
    antidepressant_dtis = dtis & antidepressant_events
    @antidepressant_dtis = antidepressant_dtis.count
    high_folate_dtis = dtis & high_folate_events
    @high_folate_dtis = high_folate_dtis.count
    low_folate_dtis = dtis & low_folate_events
    @low_folate_dtis = low_folate_dtis.count
    dysregulation_dtis = dtis & dysregulation_events
    @dysregulation_dtis = dysregulation_dtis.count
    control_dtis = dtis & control_events
    @control_dtis = control_dtis.count
    @total_calc_dtis = @cannabis_dtis + @smoker_dtis + @antidepressant_dtis + @high_folate_dtis + @low_folate_dtis + @dysregulation_dtis + @control_dtis
    @total_dtis = InitialScanQuality.find(:all, :conditions => "sequence_id = 2").count

    # poor DTIs
    poor_dtis = []
    InitialScanQuality.find(:all, :conditions => "sequence_id = 2 AND rating < 2").each {|d| poor_dtis << d.event_id }
    cannabis_poor_dtis = poor_dtis & cannabis_events
    @cannabis_poor_dtis = cannabis_poor_dtis.count
    smoker_poor_dtis = poor_dtis & smoker_events
    @smoker_poor_dtis = smoker_poor_dtis.count
    antidepressant_poor_dtis = poor_dtis & antidepressant_events
    @antidepressant_poor_dtis = antidepressant_poor_dtis.count
    high_folate_poor_dtis = poor_dtis & high_folate_events
    @high_folate_poor_dtis = high_folate_poor_dtis.count
    low_folate_poor_dtis = poor_dtis & low_folate_events
    @low_folate_poor_dtis = low_folate_poor_dtis.count
    dysregulation_poor_dtis = poor_dtis & dysregulation_events
    @dysregulation_poor_dtis = dysregulation_poor_dtis.count
    control_poor_dtis = poor_dtis & control_events
    @control_poor_dtis = control_poor_dtis.count
    @total_calc_poor_dtis = @cannabis_poor_dtis + @smoker_poor_dtis + @antidepressant_poor_dtis + @high_folate_poor_dtis + @low_folate_poor_dtis + @dysregulation_poor_dtis + @control_poor_dtis
    @total_poor_dtis = InitialScanQuality.find(:all, :conditions => "sequence_id = 2 AND rating < 2").count
    
    # Resting State
    rss = []
    InitialScanQuality.find(:all, :conditions => "sequence_id = 5 OR sequence_id = 6").each {|r| rss << r.event_id }
    cannabis_rss = rss & cannabis_events
    @cannabis_rss = cannabis_rss.count
    smoker_rss = rss & smoker_events
    @smoker_rss = smoker_rss.count
    antidepressant_rss = rss & antidepressant_events
    @antidepressant_rss = antidepressant_rss.count
    high_folate_rss = rss & high_folate_events
    @high_folate_rss = high_folate_rss.count
    low_folate_rss = rss & low_folate_events
    @low_folate_rss = low_folate_rss.count
    dysregulation_rss = rss & dysregulation_events
    @dysregulation_rss = dysregulation_rss.count
    control_rss = rss & control_events
    @control_rss = control_rss.count
    @total_calc_rss = @cannabis_rss + @smoker_rss + @antidepressant_rss + @high_folate_rss + @low_folate_rss + @dysregulation_rss + @control_rss
    @total_rss = InitialScanQuality.find(:all, :conditions => "sequence_id = 5 OR sequence_id = 6").count

    # poor Resting State
    poor_rss = []
    InitialScanQuality.find(:all, :conditions => "sequence_id = 5 AND rating < 2").each {|d| poor_rss << d.event_id }
    cannabis_poor_rss = poor_rss & cannabis_events
    @cannabis_poor_rss = cannabis_poor_rss.count
    smoker_poor_rss = poor_rss & smoker_events
    @smoker_poor_rss = smoker_poor_rss.count
    antidepressant_poor_rss = poor_rss & antidepressant_events
    @antidepressant_poor_rss = antidepressant_poor_rss.count
    high_folate_poor_rss = poor_rss & high_folate_events
    @high_folate_poor_rss = high_folate_poor_rss.count
    low_folate_poor_rss = poor_rss & low_folate_events
    @low_folate_poor_rss = low_folate_poor_rss.count
    dysregulation_poor_rss = poor_rss & dysregulation_events
    @dysregulation_poor_rss = dysregulation_poor_rss.count
    control_poor_rss = poor_rss & control_events
    @control_poor_rss = control_poor_rss.count
    @total_calc_poor_rss = @cannabis_poor_rss + @smoker_poor_rss + @antidepressant_poor_rss + @high_folate_poor_rss + @low_folate_poor_rss + @dysregulation_poor_rss + @control_poor_rss
    @total_poor_rss = InitialScanQuality.find(:all, :conditions => "sequence_id = 5 OR sequence_id = 6 AND rating > 2").count
    
    # Resting State 5 min
    rs5s = []
    InitialScanQuality.find(:all, :conditions => "sequence_id = 5").each {|r| rs5s << r.event_id }
    cannabis_rs5s = rs5s & cannabis_events
    @cannabis_rs5s = cannabis_rs5s.count
    smoker_rs5s = rs5s & smoker_events
    @smoker_rs5s = smoker_rs5s.count
    antidepressant_rs5s = rs5s & antidepressant_events
    @antidepressant_rs5s = antidepressant_rs5s.count
    high_folate_rs5s = rs5s & high_folate_events
    @high_folate_rs5s = high_folate_rs5s.count
    low_folate_rs5s = rs5s & low_folate_events
    @low_folate_rs5s = low_folate_rs5s.count
    dysregulation_rs5s = rs5s & dysregulation_events
    @dysregulation_rs5s = dysregulation_rs5s.count
    control_rs5s = rs5s & control_events
    @control_rs5s = control_rs5s.count
    @total_calc_rs5s = @cannabis_rs5s + @smoker_rs5s + @antidepressant_rs5s + @high_folate_rs5s + @low_folate_rs5s + @dysregulation_rs5s + @control_rs5s
    @total_rs5s = InitialScanQuality.find(:all, :conditions => "sequence_id = 5").count

    # poor Resting State 5 min
    poor_rs5s = []
    InitialScanQuality.find(:all, :conditions => "sequence_id = 5 AND rating < 2").each {|r| poor_rs5s << r.event_id }
    cannabis_poor_rs5s = poor_rs5s & cannabis_events
    @cannabis_poor_rs5s = cannabis_poor_rs5s.count
    smoker_poor_rs5s = poor_rs5s & smoker_events
    @smoker_poor_rs5s = smoker_poor_rs5s.count
    antidepressant_poor_rs5s = poor_rs5s & antidepressant_events
    @antidepressant_poor_rs5s = antidepressant_poor_rs5s.count
    high_folate_poor_rs5s = poor_rs5s & high_folate_events
    @high_folate_poor_rs5s = high_folate_poor_rs5s.count
    low_folate_poor_rs5s = poor_rs5s & low_folate_events
    @low_folate_poor_rs5s = low_folate_poor_rs5s.count
    dysregulation_poor_rs5s = poor_rs5s & dysregulation_events
    @dysregulation_poor_rs5s = dysregulation_poor_rs5s.count
    control_poor_rs5s = poor_rs5s & control_events
    @control_poor_rs5s = control_poor_rs5s.count
    @total_calc_poor_rs5s = @cannabis_poor_rs5s + @smoker_poor_rs5s + @antidepressant_poor_rs5s + @high_folate_poor_rs5s + @low_folate_poor_rs5s + @dysregulation_poor_rs5s + @control_poor_rs5s
    @total_poor_rs5s = InitialScanQuality.find(:all, :conditions => "sequence_id = 5 AND rating < 2").count
    
    # Resting State 8 min
    rs8s = []
    InitialScanQuality.find(:all, :conditions => "sequence_id = 6").each {|d| rs8s << d.event_id }
    cannabis_rs8s = rs8s & cannabis_events
    @cannabis_rs8s = cannabis_rs8s.count
    smoker_rs8s = rs8s & smoker_events
    @smoker_rs8s = smoker_rs8s.count
    antidepressant_rs8s = rs8s & antidepressant_events
    @antidepressant_rs8s = antidepressant_rs8s.count
    high_folate_rs8s = rs8s & high_folate_events
    @high_folate_rs8s = high_folate_rs8s.count
    low_folate_rs8s = rs8s & low_folate_events
    @low_folate_rs8s = low_folate_rs8s.count
    dysregulation_rs8s = rs8s & dysregulation_events
    @dysregulation_rs8s = dysregulation_rs8s.count
    control_rs8s = rs8s & control_events
    @control_rs8s = control_rs8s.count
    @total_calc_rs8s = @cannabis_rs8s + @smoker_rs8s + @antidepressant_rs8s + @high_folate_rs8s + @low_folate_rs8s + @dysregulation_rs8s + @control_rs8s
    @total_rs8s = InitialScanQuality.find(:all, :conditions => "sequence_id = 6").count

    # poor Resting State 8 min
    poor_rs8s = []
    InitialScanQuality.find(:all, :conditions => "sequence_id = 6 AND rating < 2").each {|d| poor_rs8s << d.event_id }
    cannabis_poor_rs8s = poor_rs8s & cannabis_events
    @cannabis_poor_rs8s = cannabis_poor_rs8s.count
    smoker_poor_rs8s = poor_rs8s & smoker_events
    @smoker_poor_rs8s = smoker_poor_rs8s.count
    antidepressant_poor_rs8s = poor_rs8s & antidepressant_events
    @antidepressant_poor_rs8s = antidepressant_poor_rs8s.count
    high_folate_poor_rs8s = poor_rs8s & high_folate_events
    @high_folate_poor_rs8s = high_folate_poor_rs8s.count
    low_folate_poor_rs8s = poor_rs8s & low_folate_events
    @low_folate_poor_rs8s = low_folate_poor_rs8s.count
    dysregulation_poor_rs8s = poor_rs8s & dysregulation_events
    @dysregulation_poor_rs8s = dysregulation_poor_rs8s.count
    control_poor_rs8s = poor_rs8s & control_events
    @control_poor_rs8s = control_poor_rs8s.count
    @total_calc_poor_rs8s = @cannabis_poor_rs8s + @smoker_poor_rs8s + @antidepressant_poor_rs8s + @high_folate_poor_rs8s + @low_folate_poor_rs8s + @dysregulation_poor_rs8s + @control_poor_rs8s
    @total_poor_rs8s = InitialScanQuality.find(:all, :conditions => "sequence_id = 6 AND rating < 2").count
    
    #@pre_noshows = Event.find(:all, :conditions => ["event_status = 2"]).count
    #@pre_canceled = Event.find(:all, :conditions => ["event_status = 3"]).count
    #@post_unwilling_children = Event.find(:all, :conditions => ["event_status = 4"]).count
    #@post_unwilling_parents = Event.find(:all, :conditions => ["event_status = 5"]).count
    #@completed_partially = Event.find(:all, :conditions => ["event_status = 6"]).count
    #@completed_fully = Event.find(:all, :conditions => ["event_status = 7"]).count
  end

  def complete_scans
    #@events = Event.find(:all, :conditions => ["study_procedure_id = 1 AND event_status > 5"])
    @events = Event.find_by_sql("SELECT events.id AS event_id, events.enrollment_id, events.procedure_id, events.event_status, enrollments.id, enrollments.subject_id, subjects.id, subjects.generation_r 
        FROM events, enrollments, subjects 
        WHERE events.enrollment_id = enrollments.id
        AND events.procedure_id NOT BETWEEN 3 AND 7
        AND events.event_status > 5 
        AND enrollments.subject_id = subjects.id;")
  end

  def missing_ratings(image_type_id)
    events = []
    Event.find(:all).each {|e| events << e.id }
    
    t1s = []
    InitialScanQuality.find(:all, :conditions => "sequence_id = 1").each {|t| t1s << t.event_id }
    
    missing = events - t1s
    
    @events = Event.find(missing)
  end
end
