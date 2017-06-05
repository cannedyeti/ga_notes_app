require 'httparty'

class UserController < ApplicationController
  include HTTParty

  def index
    if @current_user
      @user = @current_user
      # @public_notes = Note.where("whitelist = '{}'", user_id: @user.id)
      @public_notes = Note.where("user_id = ? AND whitelist = ?", *[@user.id, "{}"])
      @location = @user.location_id ? Location.find(@user.location_id) : ''
      @course = @user.default_course_id ? Course.find(@user.default_course_id) : ''
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
    @location = @user.location_id ? Location.find(@user.location_id) : ''
    @course = @user.default_course_id ? Course.find(@user.default_course_id) : ''
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
          if user_params[:photo]
            if !is_photo_url_valid(user_params[:photo])
              flash[:danger] = "Please provide a valid photo url. Note: urls should start with http:// or https://"
            else
              user.update(remove_unwanted_params(user_params, isChangingPassword))
              flash[:success] = "Profile Updated"
            end
          else
            user.update(remove_unwanted_params(user_params, isChangingPassword))
            flash[:success] = "Profile Updated"
          end
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

  def is_photo_url_valid(url)
    # handle httparty errors for improperly formatted urls
    begin
      resp = HTTParty.get(URI.parse(url))
    rescue HTTParty::Error
      return false
    rescue StandardError
      return false
    end

    if resp.code == 200
      return resp.headers['Content-Type'].start_with? 'image'
    else
      return false
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
    @courses = Course.where("is_official_course")
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :name, :photo, :default_course_id, :location_id,
    :password_digest_current, :password_digest_new, :password_digest_check, :favorites => [])
  end
end
