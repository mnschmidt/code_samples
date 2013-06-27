class StudiesController < ApplicationController
  active_scaffold :study do |config|
    config.list.columns = [:id, :title, :start_date, :end_date, :status, :user, :enrollments]
    config.create.columns = []
    config.update.columns = []
    #config.create.columns = [:first_name, :last_name, :date_of_birth, :sex, :research_status, :note]
    #config.columns[:site].form_ui = :select
    #config.nested.add_link("Company's contacts", [:contacts])
    #config.columns[:ignore_event].form_ui = :checkbox

    #config.nested.add_link "Events", [:events]
    config.list.per_page = 250
  end
end 