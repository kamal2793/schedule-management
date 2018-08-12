class AuthenticateUser
  attr_accessor :email, :password

  #this is where parameters are taken when the command is called
  def initialize(email, password)
    @email = email
    @password = password
  end

  #this is where the result gets returned
  def encoded_token
    JsonWebToken.encode(user_id: user.id) if user
  end

  private

  def user
    user = User.find_by_email(email)
    return user if user && user.authenticate(password)
    raise ExceptionHandler::BadRequest, 'Invalid credentials.'
  end
end