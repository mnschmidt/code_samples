class StudyProcedure < ActiveRecord::Base
  belongs_to :study
  belongs_to :procedure
  #has_many  :events

  def to_label
    "#{procedure.description}"
  end
end
