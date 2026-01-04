class PostsController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create ]
  def index
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    if @post.save
      flash[:notice] = "投稿しました"
      redirect_to root_path
    else
      flash[:notice] = "投稿に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def destroy
  end

  private

  def post_params
    params.expect(post: [ :title, :content ])
  end
end
