class SessionsController < ApplicationController

  def create
    temp_param = user_params
    temp_param[:email] = user_params[:email].downcase
    user = User.authenticate(temp_param)
    if user
      if user != -1
        session[:user_id] = user.id
        redirect_to "/profile"
      else
        flash[:danger] = "Your account has been deactivated, please contact an admin for further assistance."
        redirect_to login_path
      end
    else
      flash[:danger] = "Credentials Invalid."
      redirect_to login_path
    end
  end


  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
