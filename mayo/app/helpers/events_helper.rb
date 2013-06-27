module EventsHelper
  def event_status_column(record)
    event_status_name = {
      0  => 'Rescheduled',
      1  => 'Scheduled',
      2  => 'No show',
      3  => 'Canceled',
      4  => 'Unwilling child',
      5  => 'Unwilling parent',
      10 => 'Try again at a later date',
      11 => 'Partially successful; try again at a later date',
      6  => 'Partially successful',
      7  => 'Completely successful'
    }
    record.event_status = event_status_name[record.event_status]
  end

  def event_procedure_form_column(record, options)
    collection_select(:record, :procedure_id, Study.find(record.enrollment.study.id).procedures, :id, :description, {:include_blank => ' - select - '}, options)
  end
end