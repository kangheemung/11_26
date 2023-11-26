class Api::V1::PostsController < ApplicationController
def index
  jwt_authenticate
   if @current_user.nil?
    render json: { status: 401, error: "Unauthorized" }
    return
   end
   token = encode(@current_user.id) 
   posts=Post.all
   render json: { status: 201, data:{ posts:posts, token: token }}
   
end
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
    #token = encode(@current_user.id) # 正しいuser_idを使用する
    
    post = @current_user.posts.build(post_params)
    if post.save
      render json: { status: 201, data: post, token: token }
    else
      render json: { status: 422, errors: post.errors.full_messages }
    end
end
def show
  jwt_authenticate

  if @current_user.nil?
    render json: { status: 401, error: "Unauthorized" }
    return
  end

  # Use the posts association to find the post by ID
  post = @current_user.posts.find_by(id: params[:id])

  # Check if the post was found
  if post
    token = encode(@current_user.id) # Ensure this method exists and is correctly implemented
    render json: { status: 200, data: post, token: token }
  else
    render json: { status: 404, error: "Post not found" }
  end
end


def update
  jwt_authenticate

  if @current_user.nil?
    render json: { status: 401, error: "Unauthorized" }
    return
  end
  
  # Find the specific post by ID and ensure it belongs to the current user
  post = @current_user.posts.find_by(id: params[:id])

  if post.nil?
    render json: { status: 404, error: "Post not found" }
    return
  end
  
  token = encode(@current_user.id)

  # Attempt to update the post with the provided parameters
  if post.update(post_params)
    render json: { status: 200, data: post, token: token }
  else
    render json: { status: 422, error: "Unprocessable Entity", details: post.errors.full_messages }
  end
end


private
def post_params
  params.require(:post).permit(:title,:body,:user_id)
end
end
