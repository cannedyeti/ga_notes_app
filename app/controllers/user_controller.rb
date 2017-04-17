class UserController < ApplicationController
  def index
    @user = @current_user
  end

  def show
    @users = User.all
  end

  def create
    User.create(user_params)
    redirect_to login_path
  end

  def update
    u = User.find(@current_user.id)
    u.update(user_params)
    redirect_to "/profile"
  end

  def destroy
  end

  def edit
    @user = @current_user
  end

  def new
    @user = User.new
    @locations = Location.all
    @courses = Course.all
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :name, :photo, :default_course_id, :location_id)
  end
end
