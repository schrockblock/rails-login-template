class Api::V1::SessionsController < Api::V1::ApiController
  inherit_resources
  load_and_authorize_resource
  skip_load_and_authorize_resource :only => [:new, :create]

  def login
  end

  def new
  end

  def create
    s = "started with param[:name]=#{params[:session][:username]}, "
    @user = User.where("username = '#{params[:session][:username]}' AND password = '#{params[:session][:password]}'").first
    s += "found user: #{@user.username}, " if @user
    if @user
      @current_user = @user
      s += "authenticated"
      if params[:session][:html]
        s += "recognized as html"
        cookies.permanent[:api_key] = @user.api_key
        redirect_to "/secrets/show.html"
      else
        respond_with(@user) do |format|
          format.json { render :json =>  @user.as_json(:include => [:api_key]) }
        end
      end
    else
      s += "error."
      render(:json => { :errors => "Invalid name or password"+ ". Debug: " + s }.to_json, :status => 401)
    end
  end
end
