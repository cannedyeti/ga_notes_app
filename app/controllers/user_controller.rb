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
      @privilegeMap = {
        1 => "Basic",
        2 => "Admin",
      }
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
    @privilegeMap = {
      1 => "Basic",
      2 => "Admin",
    }
  end

  def create
    temp_param = user_params
    temp_param[:email] = user_params[:email].downcase
    User.create(temp_param)
    redirect_to login_path
  end

  def update
    if @current_user
      isChangingPassword = false
      #NEED TO DO password length validation?
      u = User.find(@current_user.id)
      #user is changing their password
      if !user_params[:password_digest_new].blank?
        if user_params[:password_digest_new] != user_params[:password_digest_check]
          flash[:danger] = "Password Confirmation doesn't match New Password."
          redirect_to "/profile"
          return
        end
        isChangingPassword = true
      end

      params = {:password => user_params[:password_digest_current], :email => u.email}
      user = User.authenticate(params)
      if user
        if user != -1
          user.update(remove_unwanted_params(user_params, isChangingPassword))
          flash[:success] = "Profile Updated"
        else
          flash[:danger] = "Current Password is invalid."
        end
      else
        flash[:danger] = "Current Password is invalid."
      end
      redirect_to "/profile"
    else
      redirect_to "/"
      flash[:warning] = "Please log in before doing that."
    end
  end

  def remove_unwanted_params(user_params, isChangingPassword)
    if isChangingPassword
      user_params[:password] = user_params[:password_digest_new]
    end
    user_params.delete(:password_digest_new)
    user_params.delete(:password_digest_current)
    user_params.delete(:password_digest_check)
    return user_params
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
    params.require(:user).permit(:email, :password, :name, :photo, :default_course_id, :location_id,
    :password_digest_current, :password_digest_new, :password_digest_check, :favorites => [])
  end
end
