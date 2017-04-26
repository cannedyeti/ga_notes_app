class AdminController < ApplicationController
  def allusers
    if @current_user && (@current_user.privilege == 2)
      @public_notes = Note.where("user_id = ? AND whitelist = ?", *[@current_user.id, "{}"])
      @users = User.all.order(points: :desc)
      @privileges = Privilege.all
    else
      redirect_to '/notes'
      flash[:warning] = "Invalid permissions"
    end
  end

  def allnotes
    if @current_user && (@current_user.privilege == 2)
    #only get notes that aren't private
      @public_notes = Note.where("user_id = ? AND whitelist = ?", *[@current_user.id, "{}"])
      @notes = Note.where("whitelist = '{}'").order(down_votes: :desc)
      @typeMap = {
        0 => "Public",
        1 => "Private",
        2 => "Shared"
      }
    else
      redirect_to '/'
      flash[:warning] = "Invalid permissions"
    end
  end

  def allcourses
    if @current_user && (@current_user.privilege == 2)
      @public_notes = Note.where("user_id = ? AND whitelist = ?", *[@current_user.id, "{}"])
      @courses = Course.all.order(id: :asc)
    else
      redirect_to '/'
      flash[:warning] = "Invalid permissions"
    end
  end

  def toggle_deactivate
    if @current_user && (@current_user.privilege == 2)
      u = User.find(params[:id])
      is_active = !u.is_active
      u.update(is_active: is_active)
      redirect_to :back
    else
      redirect_to '/'
      flash[:warning] = "Invalid permissions"
    end
  end

  def update_privilege
    if @current_user && (@current_user.privilege == 2)
      u = User.find(params[:id])
      u.update(user_params)
      flash[:success] = "Updated privileges for " + u.name
      redirect_to :back
    else
      redirect_to '/'
      flash[:warning] = "Invalid permissions"
    end
  end

  private

  def user_params
    params.require(:user).permit(:privilege)
  end
end
