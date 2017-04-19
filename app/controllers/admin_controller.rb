class AdminController < ApplicationController
  def allusers
    @users = User.all.order(points: :desc)
    @privilegeMap = {
      0 => "Basic",
      1 => "Moderator",
      2 => "Admin"
    }
  end

  def allnotes
    @notes = Notes.all
  end
end
