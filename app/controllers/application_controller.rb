class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_admin, :current_admin_name

  protected

  def current_admin
    @current_admin ||= User.find(session[:admin_user_id]) if session[:admin_user_id]
    @current_admin
  end

  def current_admin_name
    current_admin.try(:name)
  end

  def require_admin
    authenticate_or_request_with_http_basic('Please enter your username and password') do |username, password|
      if (user = User.where(:admin => true, :name => username).first)
        session[:admin_user_id] = user.authenticate(password)
      else
        false
      end
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, :alert => exception.message }
      format.json { render :json => { :errors => exception.message }.to_json, :status => :forbidden }
    end
  end
end
