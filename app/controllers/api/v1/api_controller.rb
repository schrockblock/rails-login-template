class Api::V1::ApiController < ApplicationController
 respond_to :json

  before_filter :set_default_response_format
  before_filter :set_default_response_headers

  helper_method :current_user, :logged_in?

  skip_before_filter :verify_authenticity_token

  protected

  def current_user
    unless @current_user
      key = request.headers['X-RAILS-Authorization'] || params[:_key] || cookies[:api_key]
      if key.blank?
        raise ApiKeyNotFound
      end

      @current_user = User.where(:api_key => key).first
      unless @current_user
        raise ApiKeyInvalid
      end
    end
    @current_user
  end

  def logged_in?
    !!current_user
  end

  def set_default_response_format
    request.format = 'json' if params[:format].blank?
  end

  def set_default_response_headers
    response.headers['Cache-Control'] = 'no-cache, no-store'
  end

  def load_index_from_nested_resource(parent, association)
    res = nil

    res.send(association)
    rescue ActiveRecord::RecordNotFound
      raise CanCan::AccessDenied.new("Not authorized to access members of that #{parent}")
    end

  class ApiKeyNotFound < CanCan::AccessDenied
    def initialize(msg = "API key not found")
      super(msg)
    end
  end

  class ApiKeyInvalid < CanCan::AccessDenied
    def initialize(msg = "API key is invalid")
      super(msg)
    end
  end
end
