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
      return render_not_found 'achou não' unless user
      return render_error 'errooou' unless user.valid_password? params[:password]

      sign_in user
      render json: user
    end

    private

    def user_params
      params.require(:user).permit(:email, :password, :name)
    end
  end
end
