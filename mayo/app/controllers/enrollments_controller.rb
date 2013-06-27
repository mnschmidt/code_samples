class EnrollmentsController < ApplicationController
  active_scaffold :enrollment do |config|
    config.list.columns = [:subject, :study]
    config.create.columns = [:subject, :study, :study_group, :status, :note, :created_by]
    config.update.columns = [:study_group, :status, :note, :created_by, :updated_by]
    config.columns[:study].form_ui = :select
    config.columns[:study].options = {:options => [[' - select - ',nil],['Cannabis, Nutrients, and Antidepressants',100],['Neonatal Pain',101]]}
    config.columns[:status].form_ui = :select
    config.columns[:status].options = {:options => [[" - select - ",nil],["Active",1],["Refused - Unwilling parent",2],["Refused - Unwilling child",3],["Asked to be called back",4],["Other",5]]}
    config.nested.add_link :events
    config.list.per_page = 50
  end
end 