class UsersController < ApplicationController
  include SessionsHelper

  before_action :signed_in_user,
                 only: [:edit, :update, :index, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
  		# flash[:success] = "Welcome to the Sample App!"
  		# sign_in @user
      # redirect_to @user
      @user.update_attribute(:password_reset_token, SecureRandom.urlsafe_base64)
      # @user.save!
      UserMailer.confirmation_mail(@user).deliver
      render 'confirmation_reminder'
  	else
		  render 'new'
  	end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Edit successfull"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_path
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def activate
    @user = User.find(params[:id])
    if @user.password_reset_token == params[:password_reset_token]
      @user.activated_state = true
      @user.password_reset_token = ''
      @user.save(validate: false)
    else
      render 'static_pages/home'
    end
  end

  private



    
    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url unless current_user?(@user)
    end

    def admin_user
      # raise @current_user.inspect
      redirect_to root_path unless current_user.admin?
    end
end
