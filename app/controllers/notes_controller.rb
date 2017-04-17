class NotesController < ApplicationController
  def index
  end

  def new
    @note = Note.new
    @courses = Course.all
  end

  def create
    @n = Note.new(note_params)
    @n.save!
    redirect_to "/notes/#{@n.id}"
  end

  def update
    n = Note.find(params[:id])
    n.update(note_params)
    redirect_to "/notes/#{n.id}"
  end

  def destroy
    Note.find(params[:id]).delete
    redirect_to '/courses'
  end

  def edit
    @note = Note.find(params[:id])
  end

  def show
    @note = Note.find(params[:id])
    # render html: @note.content.html_safe
    # respond_to do |format|
    #   format.html { render :text => @note.content }
    # end
  end

  private
  def note_params
    params.require(:note).permit(:title, :content, :user_id, :course_id)
  end

end
