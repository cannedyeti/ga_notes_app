class TagsController < ApplicationController
  def index
  end

  def new
  end

  def create
  end

  def show
  end

  def destroy
    #delete the association, not the tag
    note = Note.find(params[:note_id])
    tag = Tag.find(params[:tag_id])
    note.tags.delete(tag)
    redirect_to "/notes/#{params[:note_id]}/edit"
  end

  private

  def tag_params
    params.require(:tag).permit(:tag_name, :note_ids => [])
  end

end
