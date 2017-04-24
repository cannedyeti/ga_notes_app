class UserController < ApplicationController
  def index
    @user = @current_user
    # @public_notes = Note.where("whitelist = '{}'", user_id: @user.id)
    @public_notes = Note.where("user_id = ? AND whitelist = ?", *[@user.id, "{}"])
    @location = Location.find(@user.location_id)
    @course = Course.find(@user.default_course_id)
    @locations = Location.all
    @courses = Course.all
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
    isChangingPassword = false
    #password length validation?
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
  end

  def remove_unwanted_params(user_params, isChangingPassword)
    if isChangingPassword
      user_params[:password] = user_params[:password_digest_new]
      puts "we are changing the password to " + user_params[:password]
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
