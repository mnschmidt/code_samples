class Procedure < ActiveRecord::Base
  has_many :study_procedures
  has_many :events
  
  def to_label
    "#{description}"
  end
end
