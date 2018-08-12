class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user

  include ExceptionHandler
  include ActionValidator

  private
  def authenticate_request
    @current_user = AuthenticateApiRequest.new(request.headers).authenticate_request
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end
end
