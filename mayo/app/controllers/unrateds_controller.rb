class UnratedsController < ApplicationController
  layout "standard"
  active_scaffold :initial_scan_quality do |config|
    config.label = "Unrated scans"
    config.list.columns = [:r_number, :event, :sequence]
    config.create.columns = [:sequence, :user, :rating, :note]
    config.update.columns = [:sequence, :user, :rating, :note]
    config.columns[:user].form_ui = :select
    config.columns[:event].form_ui = :select
    config.columns[:sequence].form_ui = :select
    config.columns[:rating].form_ui = :select
    config.columns[:rating].options = {:options => [[" - Unrated - ",777],["Excellent - practically a stone",5],["Very good - only slight bits movement, definitely useable",4],["Sufficient - probably useable",3],["Fair - unclear if correction will render it useable",2],["Poor - unlikely useable",1],["Unuseable, for any reason",0],["Not collected",-1]]}
    ##config.nested.add_link("Company's contacts", [:contacts])
    #config.nested.add_link "Enrollments", [:enrollments]
    #config.nested.add_link "Events", [:events]
    config.list.per_page = 50
  end

  def conditions_for_collection
    @condition = ['rating = 777 AND sequence_id != 2 AND sequence_id != 7 AND sequence_id != 10 AND sequence_id != 11 AND sequence_id != 12']
  end
end 