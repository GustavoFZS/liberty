# frozen_string_literal: true

module Api
  module V1
    class ApiController < ActionController::Base
      skip_before_action :verify_authenticity_token
      before_action :set_locale
      before_action :authenticate_user

      private

      def render_error(message, status = 422)
        render json: { message: message }, status: status
      end

      def render_not_found(message)
        render_error(message, 404)
      end

      def render_not_authorized
        render_error(I18n.t('api.not_authorized'), 401)
      end

      def set_locale
        I18n.locale = request.headers[:locale] || I18n.default_locale
      end

      def authenticate_user
        header = request.headers['Authorization']
        header = header.split(' ').last if header

        @current_user = User.by_token(header)
        render_not_authorized unless @current_user
      rescue JWT::DecodeError
        render_not_authorized
      end

      def current_user
        @current_user
      end
    end
  end
end
