module ExceptionHandler
  extend ActiveSupport::Concern

  # Define custom error subclasses - rescue catches `StandardErrors`
  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end
  class ExpiredSignature < StandardError; end
  class DecodeError < StandardError; end
  class BadRequest < StandardError; end

  included do
    # Define custom handlers
    rescue_from ActiveRecord::RecordInvalid,           with: :render_unprocessable_entity
    rescue_from ActiveRecord::RecordNotFound,          with: :render_not_found
    rescue_from ExceptionHandler::AuthenticationError, with: :render_unauthorized_request
    rescue_from ExceptionHandler::MissingToken,        with: :render_unprocessable_entity
    rescue_from ExceptionHandler::InvalidToken,        with: :render_unprocessable_entity
    rescue_from ExceptionHandler::ExpiredSignature,    with: :render_unauthorized_request
    rescue_from ExceptionHandler::DecodeError,         with: :render_unauthorized_request
    rescue_from ExceptionHandler::BadRequest,          with: :render_bad_request
  end

  private

  def render_unprocessable_entity(e)
    render json: { message: e.message }, status: :unprocessable_entity
  end

  def render_bad_request(e)
    render json: { message: e.message }, status: :unprocessable_entity
  end

  def render_unauthorized_request(e)
    render json: { message: e.message }, status: :unauthorized
  end

  def render_not_found(e)
    render json: { message: e.message }, status: :unprocessable_entity
  end
end