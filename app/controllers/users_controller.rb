class UsersController < ApplicationController
  before_action :logged_in_user, except: [:show, :new, :create]
  before_action :admin_user, only: :destroy
  before_action :find_user, except: [:new, :create, :index]
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.paginate page: params[:page]
  end

  def show
    @microposts = @user.microposts.paginate page: params[:page]
    @follow = current_user.active_relationships.build
    @unfollow = current_user.active_relationships.find_by(followed_id: @user.id)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "check_mail"
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "profile"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] =  t "user_del"
    redirect_to users_path
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t "mess_login"
      redirect_to login_path
    end
  end

  def correct_user
    redirect_to root_path unless @user.current_user? current_user
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def find_user
    @user = User.find_by id: params[:id]
    unless @user
      flash[:success] = t "data_not_exist"
      redirect_to root_path
    end
  end
end
