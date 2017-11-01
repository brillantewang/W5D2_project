class PostsController < ApplicationController
  before_action :require_authorship, only: [:edit, :update, :destroy]

  def new
    @post = Post.new
    render :new
  end

  def create
    @post = Post.new(post_params)
    @post.sub_id = params[:sub_id]
    @post.author_id = current_user.id

    if @post.save
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :new
    end
  end

  def edit
    @post = Post.find_by(id: params[:id])
    render :edit
  end

  def update
    @post = Post.find_by(id: params[:id])

    if @post.update(post_params)
      redirect_to post_url(@post)
    else
      flash[:errors] = @post.errors.full_messages
      redirect_to edit_post_url(@post)
    end
  end

  def show
    @post = Post.find_by(id: params[:id])
    render :show
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy
    redirect_to sub_url(@post.sub)
  end

  private

  def post_params
    params.require(:post).permit(:title, :url, :content, sub_ids: [])
  end

  def require_authorship
    @post = Post.find_by(id: params[:id])
    unless current_user.posts.include?(@post)
      flash[:errors] = ["You are not the author"]
      redirect_to post_url(@post)
    end
  end
end
