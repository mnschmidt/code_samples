class StudyGroup < ActiveRecord::Base
  belongs_to :study
  has_many :enrollments
  has_many :events, :through => :enrollments
end
