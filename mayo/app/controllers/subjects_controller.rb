class SubjectsController < ApplicationController
  layout "standard"
  active_scaffold :subject do |config|
    config.list.columns = [:generation_r, :first_name, :last_name, :date_of_birth, :sex, :events]
    config.create.columns = [:generation_r, :first_name, :last_name, :date_of_birth, :sex, :email, :address, :house_number, :house_number_toev, :post_code, :city, :phone, :mobile, :research_status, :date_letter_sent, :note]
    config.update.columns = [:generation_r, :first_name, :last_name, :date_of_birth, :sex, :email, :address, :house_number, :house_number_toev, :post_code, :city, :phone, :mobile, :research_status, :date_letter_sent, :note]
    config.show.columns = [:date_letter_sent, :generation_r, :first_name, :last_name, :date_of_birth, :sex, :address, :house_number, :house_number_toev, :post_code, :city, :phone, :mobile, :email, :date_letter_sent, :note, :created_by, :created_at, :updated_by, :updated_at]
    config.columns[:generation_r].label = "R number"
    config.columns[:sex].form_ui = :select
    config.columns[:sex].options = {:options => [[' - select - ',nil],['Female',0],['Male',1],['Other',2]]}
    config.nested.add_link :phone_calls
    config.nested.add_link :enrollments
    config.list.per_page = 50
  end
  
  def before_create_save(record)
    @record.created_by = @login
  end

  def before_update_save(record)
    @record.updated_by = @login
  end
end 