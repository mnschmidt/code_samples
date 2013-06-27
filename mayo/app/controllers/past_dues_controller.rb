class PastDuesController < ApplicationController
  layout "standard"
  active_scaffold :event do |config|
    config.label = "Past due events"
    config.list.columns = [:id, :enrollment, :event_start_time, :procedure, :event_status]
    config.create.columns = [:enrollment, :event_start_time, :procedure, :event_status, :ignore_event, :event_note, :created_by]
    config.update.columns = [:enrollment, :event_start_time, :procedure, :event_status, :ignore_event, :event_note, :created_by, :updated_by]
    config.columns[:enrollment].form_ui = :select
    config.columns[:procedure].form_ui = :select
    config.columns[:event_start_time].options = { :format => :short, 'date:firstDay' => 1, 'time:stepMinute' => 5 }
    config.columns[:ignore_event].form_ui = :checkbox
    config.nested.add_link :initial_scan_qualities
    config.list.per_page = 50
  end
  
  def conditions_for_collection
    # only select events which are in the past and have a status of "scheduled"
    @condition = ["event_start_time < ? AND event_status = 1", Time.now.at_midnight - 1]
  end
end 