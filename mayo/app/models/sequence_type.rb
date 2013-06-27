class SequenceType < ActiveRecord::Base
  has_many :sequences
  has_many :initial_scan_qualities, :through => :sequences
end
