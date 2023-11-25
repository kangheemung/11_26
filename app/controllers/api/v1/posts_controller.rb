class Api::V1::PostsController < ApplicationController
def create
# jwt_authenticateを呼び出して認証する
    jwt_authenticate
    if @current_user.nil?
    render json: { status: 401, error: "Unauthorized" }
    return
    end
    token = encode(@current_user.id) # 正しいuser_idを使用する
    user = User.find_by(id: @current_user.id)
    if user.nil?
    render json: { status: 404, error: "User not found" }
    return
    end
    token = encode(@current_user.id) # 正しいuser_idを使用する
    
    post = @current_user.posts.build(post_params)
    if post.save
      render json: { status: 201, data: post, token: token }
    else
      render json: { status: 422, errors: post.errors.full_messages }
    end
end

private
def post_params
  params.require(:post).permit(:title,:body,:user_id)
end
end
