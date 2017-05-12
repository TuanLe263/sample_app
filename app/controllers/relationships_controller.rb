class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def index
    @title = params[:title]
    @user = User.find_by id: params[:user_id]
    if @user
      @users = @user.send(@title).paginate page: params[:page]
      render "users/show_follow"
    else
      flash[:danger] = t "data_not_exist"
      redirect_to root_url
    end
  end

  def create
    @user = User.find_by id: params[:followed_id]
    current_user.follow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
    @unfollow = current_user.active_relationships.find_by followed_id: @user.id
  end

  def destroy
    @user = Relationship.find_by(id: params[:id]).followed
    current_user.unfollow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
    @follow = current_user.active_relationships.build
  end
end
