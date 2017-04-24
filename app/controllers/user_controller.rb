class UserController < ApplicationController
  def index
    if @current_user
      @user = @current_user
      # @public_notes = Note.where("whitelist = '{}'", user_id: @user.id)
      @public_notes = Note.where("user_id = ? AND whitelist = ?", *[@user.id, "{}"])
      @location = Location.find(@user.location_id)
      @course = Course.find(@user.default_course_id)
      @locations = Location.all
      @courses = Course.all
    else 
      redirect_to "/"
      flash[:warning] = "Please log in before doing that."
    end
  end

  def show
    @user = User.find(params[:id])
    # @public_notes = Note.where("whitelist = '{}'", user_id: @user.id)
    @public_notes = Note.where("user_id = ? AND whitelist = ?", *[@user.id, "{}"])
    @location = Location.find(@user.location_id)
    @course = Course.find(@user.default_course_id)
  end

  def create
    User.create(user_params)
    redirect_to login_path
  end

  def update
    if @current_user
      u = User.find(@current_user.id)
      u.update(user_params)
      redirect_to "/profile"
    else
      redirect_to "/"
      flash[:warning] = "Please log in before doing that."
    end
  end

  def destroy
  end

  def new
    @user = User.new
    @locations = Location.all
    @courses = Course.all
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :name, :photo, :default_course_id, :location_id, :favorites => [])
  end
end
