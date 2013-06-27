module InitialScanQualitiesHelper
  def rating_column(record)
    rating_name = {
      -1 => 'Not collected',
      0  => 'Unuseable',
      1  => 'Poor',
      2  => 'Fair',
      3  => 'Good',
      4  => 'Very good',
      5  => 'Excellent',
      777 => 'Unrated'
    }
    record.rating = rating_name[record.rating]
  end
end