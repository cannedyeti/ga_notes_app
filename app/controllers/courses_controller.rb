class CoursesController < ApplicationController
  def index
    @courses = Course.all
  end

  def show
    @course = Course.find(params[:course_id])
    @notes = Note.where(:course_id => params[:course_id]).order(up_votes: :desc)
  end
end
