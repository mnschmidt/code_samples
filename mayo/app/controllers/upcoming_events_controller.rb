class UpcomingEventsController < ApplicationController
  layout "standard"
  active_scaffold :event do |config|
    config.label = "Upcoming events"
    config.list.columns = [:r_number, :subject_name, :date_of_birth, :event_status, :event_start_time, :nepsy_start, :mock_start, :mri_start, :procedure]
    config.create.columns = [:event_start_time, :procedure, :event_status, :event_note, :created_by]
    config.update.columns = [:event_start_time, :procedure, :event_status, :event_note, :created_by, :updated_by]
    config.columns[:event_status].label = "Status"
    config.columns[:event_start_time].label = "Time"
    # following line taken from http://vhochstein.wordpress.com/2010/09/18/activescaffold-using-dates-with-jquery/
    config.columns[:event_start_time].options = { :format => :short, 'date:firstDay' => 1, 'time:stepMinute' => 5 }
    config.columns[:procedure].form_ui = :select
    config.list.sorting = { :event_start_time => :asc }
    config.create.link = false
    config.nested.add_link :initial_scan_qualities
    config.list.per_page = 50
    #config.columns[:event_start_time].options[:format] = "%a, %d %b %Y" 
    @section_number = 1
  end

  def before_create_save(record)
    @record.created_by = @login
  end

  def before_update_save(record)
    @record.updated_by = @login
  end
  
  def conditions_for_collection
    # only select events which are in the future
    @condition = ["event_start_time > ?", Time.now.at_midnight]
  end
end
