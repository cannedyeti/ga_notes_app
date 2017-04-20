class AdminController < ApplicationController
  def allusers
    @users = User.all.order(points: :desc)
    @privileges = Privilege.all
  end

  def allnotes
    #only get notes that are private
    @notes = Note.where("whitelist = '{}'").order(down_votes: :desc)
    @typeMap = {
      0 => "Public",
      1 => "Private",
      2 => "Shared"
    }
  end

  def allcourses
    @courses = Course.all.order(id: :asc)
  end

  def toggle_deactivate
    u = User.find(params[:id])
    is_active = !u.is_active
    u.update(is_active: is_active)
    redirect_to :back
  end

  def update_privilege
    u = User.find(params[:id])
    u.update(user_params)
    flash[:success] = "Updated privileges for " + u.name
    redirect_to :back
  end

  private

  def user_params
    params.require(:user).permit(:privilege)
  end
end
