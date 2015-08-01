class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :followings, :followers]

  def show
    @microposts = @user.microposts
  end

  def followings
    @following_users = @user.following_users
    render 'show'
  end

  def followers
    @followed_users = @user.followed_users
    render 'show'
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path, flash: {success: 'update successful'}
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :place, :comment, :password,
                                 :password_confirmation)
  end

  def set_user
    if current_user.id == params[:id]
      @user = current_user
    else
      @user = User.find(params[:id])
    end
  end

end
