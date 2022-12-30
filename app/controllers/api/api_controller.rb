class Api::ApiController < ActionController::Base
  skip_before_action :verify_authenticity_token

  private

  def render_error(message, status = 422)
    render json: { message: message }, status: status
  end

  def render_not_found(message)
    render_error(message, 404)
  end
end
