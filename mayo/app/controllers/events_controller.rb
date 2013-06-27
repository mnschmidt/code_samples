class EventsController < ApplicationController
  active_scaffold :event do |config|
    config.list.columns = [:id, :enrollment, :event_start_time, :procedure, :event_status]
    config.create.columns = [:enrollment, :event_start_time, :procedure, :event_status, :received, :no_images_acquired, :ignore_event, :event_note, :created_by]
    config.update.columns = [:enrollment, :event_start_time, :procedure, :event_status, :received, :no_images_acquired, :ignore_event, :event_note, :created_by, :updated_by]
    config.columns[:enrollment].form_ui = :select
    config.columns[:procedure].form_ui = :select
    config.columns[:event_start_time].form_ui = :datetime_picker
    config.columns[:event_start_time].options = { :format => :long, 'date:firstDay' => 1, 'time:stepMinute' => 5 }
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
end 