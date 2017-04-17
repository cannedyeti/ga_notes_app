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
    @comments = Comment.where(:note_id => @note.id)
    @comment = Comment.new
    @user = @current_user
  end

  private
  
  def note_params
    params.require(:note).permit(:title, :content, :user_id, :course_id, :tag_ids => [])
  end

end
