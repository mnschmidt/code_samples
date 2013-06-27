class AdminController < ApplicationController
  layout 'login'
  
  def login
    if request.post?
      if params[:login].empty? || params[:password].empty?
        flash[:notice] = "Must include both login and password"
      else
        #for test purposes...uncommenting next line bypasses authentication, login is with username only. 
        #user = User.find_by_login(params[:login])
        user = User.authenticate(params[:login], params[:password])
        if user && user.active
          session[:user_id] = user.id
          if session[:return_to].nil?
            redirect_to(:controller => "upcoming_events")
          else
            redirect_to session[:return_to]
          end
        else
          flash.now[:notice] = "Invalid login or password."
        end
      end
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "You have been logged out of the system."
    redirect_to(:controller => "admin", :action => "login")
  end

  def index
    redirect_to :action => "login"
  end
end
