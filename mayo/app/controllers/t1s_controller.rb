class T1sController < ApplicationController
  layout "standard"
  active_scaffold :initial_scan_quality do |config|
    config.label = "Image quality ratings"
    config.list.columns = [:r_number, :event, :rating, :user]
    config.create.columns = [:event, :sequence, :user, :rating, :note, :created_by]
    config.update.columns = [:event, :sequence, :user, :rating, :note, :created_by, :updated_by]
    config.columns[:user].form_ui = :select
    config.columns[:event].form_ui = :select
    config.columns[:sequence].form_ui = :select
    config.columns[:rating].form_ui = :select
    config.columns[:rating].options = {:options => [[" - Unrated - ",777],["Excellent - practically a stone",5],["Very good - only slight bits movement, definitely useable",4],["Sufficient - probably useable",3],["Fair - unclear if correction will render it useable",2],["Poor - unlikely useable",1],["Unuseable, for any reason",0],["Not collected",-1]]}
    ##config.nested.add_link("Company's contacts", [:contacts])
    #config.nested.add_link "Enrollments", [:enrollments]
    #config.nested.add_link "Events", [:events]
    config.nested.add_link :freesurfer_qualities
    config.list.per_page = 100
  end
  
  def before_create_save(record)
    @record.created_by = @login
  end
  
  def before_update_save(record)
    @record.updated_by = @login
  end
  
  def conditions_for_collection
    @condition = ['sequence_id = 1']
  end
end
