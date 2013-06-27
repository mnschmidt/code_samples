class Sequence < ActiveRecord::Base
  belongs_to :sequence_type
  has_many :initial_scan_qualities
  has_many :events, :through => :initial_scan_qualities
  
  def to_label
    "#{sequence_type.name}: #{name}"
  end
end
