module PhoneCallsHelper
  def purpose_column(record)
    purpose_name = {
      1 => 'NEPSY, Mock & MRI',
      2 => 'NEPSY',
      3 => 'Mock & MRI',
      4 => 'MRI',
      9 => 'Other'
    }
    record.purpose = purpose_name[record.purpose]
  end
  def result_column(record)
    result_name = {
      1 => 'Scheduled',
      2 => 'Refused - unwilling child',
      3 => 'Refused - unwilling parent',
      4 => 'Asked to be called back',
      5 => 'Phone not answered',
      6 => 'Never answered - ending calls',
      7 => 'Other'
    }
    record.result = result_name[record.result]
  end
end