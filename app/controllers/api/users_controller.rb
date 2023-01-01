# frozen_string_literal: true

module Api
  class UsersController < ApiController
    skip_before_action :authenticate_user, only: %i[signup signin]

    def signup
      user = User.new(user_params)
      user.password = params[:password]
      return render_error user.errors.full_messages unless user.save

      render json: user
    end

    def signin
      user = User.where(email: params[:email]).last
      return render_not_found I18n.t 'api.user.not_found' unless user
      return render_error I18n.t 'api.user.invalid_password' unless user.valid_password? params[:password]

      render json: { token: user.jwt_token }
    end

    def update
      return render json: current_user if current_user.update(user_params)

      render_error current_user.errors.full_messages
    end

    def show
      render json: current_user
    end

    private

    def user_params
      params.require(:user).permit(:email, :password, :name)
    end
  end
end
