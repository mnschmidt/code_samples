class InitialScanQualitiesController < ApplicationController
  active_scaffold :initial_scan_quality do |config|
    config.list.columns = [:event, :sequence, :rating, :user]
    config.create.columns = [:event, :sequence, :user, :rating, :preferred, :note, :created_by]
    config.update.columns = [:event, :sequence, :user, :rating, :preferred, :note, :created_by, :updated_by]
    config.columns[:user].form_ui = :select
    config.columns[:event].form_ui = :select
    config.columns[:sequence].form_ui = :select
    config.columns[:rating].form_ui = :select
    config.columns[:preferred].form_ui = :checkbox
    #config.actions = [:list, :nested]
    config.columns[:rating].options = {:options => [[" - Unrated - ",777],["Excellent - practically a stone",5],["Very good - only slight bits movement, definitely useable",4],["Good - probably useable",3],["Fair - unclear if correction will render it useable",2],["Poor - unlikely useable",1],["Unuseable, for any reason",0],["Not collected",-1]]}
    config.list.per_page = 50
  end
  
  def before_create_save(record)
    @record.created_by = @login
  end
  
  def before_update_save(record)
    @record.updated_by = @login
  end
end 