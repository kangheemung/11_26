class Api::V1::UsersController < ApplicationController
  skip_before_action :jwt_authenticate, only: [:create]

  def create
    user = User.new(user_params)
    if user.save
      token = encode(user.id) # Assuming encode is defined somewhere to generate a token
      render json: {status: 200, data: {name: user.name, email: user.email, token: token}}
    else
      render json: {status: 400, error: "User can't save and create"}
    end
  end

  def show
    user = User.find_by(id: params[:id])

    if user.present?
      posts = user.posts.all
      token = encode(user.id) # Again assuming encode is defined elsewhere
      render json: {status: 200, data: {name: user.name, email: user.email, token: token, posts: posts}}
    else
      render json: {status: 404, error: "User not found"}, status: :not_found
    end
  end

  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
