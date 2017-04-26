class CoursesController < ApplicationController
  require 'rubygems'
  require 'sanitize'

  def index
    @courses = Course.all
    @tags = Tag.joins(:notes).select("tags.*, count(notes.whitelist) as scount").group("tags.id").order("scount DESC").limit(9)
    
  end

  def show
    @course = Course.find(params[:course_id])
    @notes = Note.where("course_id = ? AND whitelist = ?", *[params[:course_id], "{}"]).order(up_votes: :desc)
    @notes = @notes.paginate(:page => params[:page], :per_page => 10)
    @notes.each do |n|
      n.content = Sanitize.clean(n.content)
      n.content = n.content[0..100] + '...'
    end
    @tags = Tag.joins(:notes).select("tags.*, count(notes.id) as scount").group("tags.id").order("scount DESC").limit(10)
  end



  def new
    if @current_user.privilege == 2
      @course = Course.new
    else
      redirect_to "/"
      flash[:danger] = "You do not have the privilege to do this."
    end
  end

  def edit
    if @current_user.privilege == 2
      @course = Course.find(params[:id])
    else
      redirect_to "/"
      flash[:danger] = "You do not have the privilege to do this."
    end
  end

  def update
    if @current_user.privilege == 2
      c = Course.find(params[:id])
      c.update(course_params)
      redirect_to "/admin/allcourses"
    else
      redirect_to "/"
      flash[:danger] = "You do not have the privilege to do this."
    end
  end

  def create
    if @current_user.privilege == 2
      Course.create(course_params)
      redirect_to "/admin/allcourses"
    else
      redirect_to "/"
      flash[:danger] = "You do not have the privilege to do this."
    end
  end

  def destroy
    if @current_user.privilege == 2
      @c = Course.find(params[:id])
      @c.delete
      redirect_to :back
    else
      redirect_to "/"
      flash[:danger] = "You do not have the privilege to do this."
    end
  end

  private

  def course_params
    params.require(:course).permit(:name, :code, :description, :is_official_course)
  end
end
