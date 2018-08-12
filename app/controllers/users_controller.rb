class UsersController < ApplicationController
  skip_before_action :valid_action?, only: %i[login register]
  skip_before_action :authenticate_request, only: %i[login register]

  def register
    user = User.create!(user_params)
    render json: user, status: :created
  end

  def login
    authenticate params[:email], params[:password]
  end

  private
  def user_params
    params.permit(
      :first_name,
      :last_name,
      :email,
      :password
    )
  end

  def authenticate(email, password)
    command = AuthenticateUser.new(email, password).encoded_token
    render json: { access_token: command, message: 'Login Successful' }
  end

  def valid_login?
    param! :email, String, required: true, blank: false
    param! :password, String, required: true, blank: false
  end

  def valid_register?
    param! :first_name, String, required: true, blank: false
    param! :email, String, required: true, blank: false
    param! :password, String, required: true, blank: false
  end
end
