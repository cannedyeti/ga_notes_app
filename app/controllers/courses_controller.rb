class CoursesController < ApplicationController
  require 'rubygems'
  require 'sanitize'

  def index
    @courses = Course.all
    @tags = Tag.joins(:notes).select("tags.*, count(notes.id) as scount").group("tags.id").order("scount DESC").limit(9)
  end

  def show
    @course = Course.find(params[:course_id])
    @notes = Note.where("course_id = ? AND whitelist = ?", *[params[:course_id], "{}"]).order(up_votes: :desc)
    @notes.each do |n|
      n.content = Sanitize.clean(n.content)
      n.content = n.content[0..100] + '...'
    end
    @tags = Tag.joins(:notes).select("tags.*, count(notes.id) as scount").group("tags.id").order("scount DESC").limit(10)
  end



  def new
    @course = Course.new
  end

  def edit
    @course = Course.find(params[:id])
  end

  def update
    c = Course.find(params[:id])
    c.update(course_params)
    redirect_to "/admin/allcourses"
  end

  def create
    Course.create(course_params)
    redirect_to "/admin/allcourses"
  end

  def destroy
    @c = Course.find(params[:id])
    @c.delete
    redirect_to :back
  end

  private

  def course_params
    params.require(:course).permit(:name, :code, :description)
  end
end
