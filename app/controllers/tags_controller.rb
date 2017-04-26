class TagsController < ApplicationController
  def index
  end

  def new
  end

  def create
  end

  def show
    @notes = []
    @tag = Tag.find(params[:id])
    @tag.note_ids.each do |n|
      temp = nil
      temp = Note.where("id = ? AND whitelist = ?", *[n, "{}"]).first
      if temp
        temp.content = Sanitize.clean(temp.content)
        temp.content = temp.content[0..200] + '...'
        @notes.push(temp)
      end
    end
  end

  def destroy
    #delete the association, not the tag
    note = Note.find(params[:note_id])
    tag = Tag.find(params[:tag_id])
    note.tags.delete(tag)
    redirect_to "/notes/#{params[:note_id]}/edit"
  end

  private

  def tag_search_params
    params.require(:tag).permit(:tag_name)
  end

  def tag_params
    params.require(:tag).permit(:tag_name, :note_ids => [])
  end

end
