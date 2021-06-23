class UsersController < ApplicationController
  before_action :login?, only: [:show, :edit, :update]
  before_action :load_user, only: [:show, :edit, :update, :destroy]
  before_action :correct_user?, only: [:edit, :update]
  before_action :valid_admin?, only: :destroy
  def index
    @users = User.paginate(page: params[:page], per_page: Settings.page.per_page)
  end
  
  def show; end

  def new
    @user = User.new
  end 

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = t("welcome")
      redirect_to @user
    else
      render :new  
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to @user
    else
      render "edit"
    end
  end

  def destroy
    if @user.destroy
      flash[:success]="Delete Success"
    else
      flash[:success]="Delete Fail"
    end
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
      :password_confirmation)
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    render file: "#{Rails.root}/public/404.html", layout: false, status: 404
  end

  def correct_user?
    if @user != current_user
      flash[:danger]=t("access_denied")
      redirect_to root_path
    end
  end

  def valid_admin?
    unless current_user.admin
      flash[:danger]=t("access_denied")
      redirect_to root_path
    end 
  end
end
