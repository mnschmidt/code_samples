class MissingTransfersController < ApplicationController
  layout "standard"
  active_scaffold :event do |config|
    config.label = "Missing transfers (Events not marked as 'received')"
    config.list.columns = [:id, :r_number, :enrollment, :event_start_time, :procedure, :event_status]
    config.create.columns = [:enrollment, :event_start_time, :procedure, :event_status, :received, :no_images_acquired, :ignore_event, :event_note, :created_by]
    config.update.columns = [:enrollment, :event_start_time, :procedure, :event_status, :received, :no_images_acquired, :ignore_event, :event_note, :created_by, :updated_by]
    config.columns[:enrollment].form_ui = :select
    config.columns[:procedure].form_ui = :select
    config.columns[:event_start_time].form_ui = :datetime_picker
    #config.columns[:event_start_time].options = { :format => :long, 'date:firstDay' => 1, 'time:stepMinute' => 5 }
    config.columns[:received].form_ui = :checkbox
    config.columns[:no_images_acquired].form_ui = :checkbox
    config.columns[:ignore_event].form_ui = :checkbox
    config.nested.add_link :initial_scan_qualities
    config.list.per_page = 50
  end
  
  def before_create_save(record)
    @record.created_by = @login
  end
  
  def before_update_save(record)
    @record.updated_by = @login
  end
  
  def conditions_for_collection
    # only select events which are in the past and have don't have a status that would have no data
# old method
    #ok_statuses = [0, 1, 6, 7, 11]
    #@condition = ["received = 0 AND event_start_time > ? AND event_start_time < ? AND event_status IN (?)", '2012-05-21 00:00:00 +0200', Time.now, ok_statuses]
# new method
    ok_statuses = [0, 1, 6, 7, 11]
    mri_events = Event.find(:all, :conditions => ["procedure_id = 1 OR procedure_id = 2 OR procedure_id = 8"])
    events_without_images = Event.find(:all, :conditions => ["no_images_acquired = 1"])
    excluded_events = Study.find(101).events
    unreceived_events = Event.find(:all, :conditions => ["received = 0 AND event_start_time < ? AND event_status IN (?)", Time.now, ok_statuses])
    # exclude events that don't include an MRI
    missing_txs = unreceived_events & mri_events
    # exclude events from study 101 and events without images
    filtered_missing_transfers = missing_txs - excluded_events - events_without_images
    # now extract the id of each filtered_missing_transfers so we can use it in the @condition statement
    ids = []
    Event.find_all_by_id(filtered_missing_transfers).each {|x| ids << x.id}
    @condition = ['events.id IN (?)', ids]
  end
end 
