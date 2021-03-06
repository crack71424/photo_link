class PostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  
  def index
    @post = current_user.posts.build if logged_in?
    @posts = Post.search(params[:search]).order(created_at: :desc)
  end
  
  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = 'メッセージを投稿しました！'
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/index'
    end
  end
  
  def destroy
    @post.destroy
    flash[:success] = "投稿を削除しました"
    redirect_to request.referrer || root_url
  end
  
  private
  
  def post_params
    params.require(:post).permit(:content)
  end
  
  def correct_user
    @post = current_user.posts.find_by(id: params[:id])
    redirect_to root_url if @post.nil?
  end
end
