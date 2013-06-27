module SubjectsHelper
  def sex_column(record)
    sex_name = {
      0  => 'Female',
      1  => 'Male',
      2  => 'Other'
    }
    record.sex = sex_name[record.sex]
  end
end