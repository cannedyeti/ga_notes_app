class CoursesController < ApplicationController
  def index
    @courses = Course.all
    @tags = Tag.joins(:notes).select("tags.*, count(notes.id) as scount").group("tags.id").order("scount DESC").limit(9)

  end

  def show
    @course = Course.find(params[:course_id])
    @notes = Note.where(:course_id => params[:course_id]).order(up_votes: :desc)
  end
end
