module Api
  class UsersController < ApiController
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

      sign_in user
      render json: user
    end

    private

    def user_params
      params.require(:user).permit(:email, :password, :name)
    end
  end
end
