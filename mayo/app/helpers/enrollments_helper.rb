module EnrollmentsHelper
  def status_column(record)
    status_name = {
      1  => 'Active',
      2  => 'Refused - Unwilling parent',
      3  => 'Refused - Unwilling child',
      4  => 'Asked to be called back',
      5  => 'Other'
    }
    record.status = status_name[record.status]
  end
end