class TagsController < ApplicationController
  before_action :correct_user, only: [:destroy]
    
  def index
    @tag = current_user.tags.build if logged_in?
    @tags = Tag.search(params[:search]).order(created_at: :desc)
  end
    
  def show
    @tag = Tag.find(params[:id])
    @users = @tag.added_user
  end
  
  def create
    @tag = current_user.tags.build(tag_params)
    
    if @tag.save
      flash[:success] = "タグの投稿に成功！"
      redirect_to @tag
    else
      @tags = Tag.all.order(created_at: :desc)
      flash.now[:danger] = "タグの投稿に失敗しました"
      render 'static_pages/index'
    end
  end
  
  def destroy
    @tag.destroy
    flash[:success] = "タグの削除に成功！"
    redirect_to tags_path
  end
  
  private
  
  def tag_params
    params.require(:tag).permit(:content, :title, :image)
  end
  
  def correct_user
    @tag = current_user.tags.find_by(id: params[:id])
    redirect_to root_url if @tag.nil?
  end
end