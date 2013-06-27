class PhoneCallsController < ApplicationController
  active_scaffold :phone_call do |config|
    config.list.columns = [:id, :phone, :purpose, :result]
    config.create.columns = [:phone, :purpose, :result, :note, :created_by]
    config.update.columns = [:phone, :purpose, :result, :note, :created_by, :updated_by, :created_at, :updated_at]
    config.list.per_page = 250
  end

  def before_create_save(record)
    @record.created_by = @login
  end

  def before_update_save(record)
    @record.updated_by = @login
  end
end 