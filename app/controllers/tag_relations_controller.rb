class TagRelationsController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    tag = Tag.find(params[:tag_id])
    current_user.adding(tag)
    flash[:success] = 'タグに参加しました'
    redirect_back(fallback_location: root_path)
  end

  def destroy
    tag = Tag.find(params[:tag_id])
    current_user.remove(tag)
    flash[:success] = 'タグ参加を取り消しました'
    redirect_back(fallback_location: root_path)
  end
  
  private
  
  def require_user_logged_in
    unless logged_in?
      redirect_to login_url
    end
  end
  
end