class NotesController < ApplicationController
  def index
  end

  def new
  end

  def create
  end

  def update
  end

  def destroy
  end

  def edit
  end

  def show
    @course = Course.find(params[:course_id])
    @notes = Note.where(:course_id => params[:course_id])
  end
end
