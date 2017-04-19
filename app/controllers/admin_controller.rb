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
    #only get notes that are private
    @notes = Note.where("whitelist = '{}'").order(down_votes: :desc)
    @typeMap = {
      0 => "Public",
      1 => "Private",
      2 => "Shared"
    }
  end
end
