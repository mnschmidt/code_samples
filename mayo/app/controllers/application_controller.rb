class ApplicationController < ActionController::Base
    before_filter :check_authentication,
                  :except => :login
  #  before_filter :check_authorization,
  #                :except => :login
    before_filter :get_login,
                  :except => :login

    helper :all # include all helpers, all the time
    protect_from_forgery # See ActionController::RequestForgeryProtection for details

    # Scrub sensitive parameters from your log
    #filter_parameter_logging :password
  
  ActiveScaffold.set_defaults do |config| 
    config.ignore_columns.add [:lock_version, :deleted_at, :version, :versions]
    
    def before_create_save(record)
      @record.created_by = @login
    end

    def before_update_save(record)
      @record.updated_by = @login
    end
  end
  
  protected
    def current_user
      User.find_by_id(session[:user_id])
    end

    def get_login
      @login = current_user.login
    end

    def logged_in?
      !current_user.nil?
    end

    def user_is_admin?
      current_user.is_admin?
    end

    def check_authentication
      unless logged_in?
        session[:return_to] = request.url
        flash[:notice] ="Access denied, users must log in first."
        redirect_to :controller => :admin, :action => :login
      end
    end

    def require_user
      unless current_user
        #store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to login_path
        return false
      end
    end
end
