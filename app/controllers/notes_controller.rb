class NotesController < ApplicationController
  def index
    @notes = Note.where(:user_id => @current_user.id)
  end

  def new
    @note = Note.new
    @courses = Course.all
  end

  def create_tags(existing_tag_ids, note_params)
    tag_names = note_params[:tag_ids]
    tag_ids = []
    tag_ids.concat existing_tag_ids
    tag_names.split(/\s*,\s*/).each do |tn|
      new_tag = Tag.find_or_create_by(tag_name: tn)
      tag_ids.push(new_tag.id)
    end
    note_params[:tag_ids] = tag_ids
    return note_params
  end

  def create
    #create the post
    @n = Note.new(create_tags([], note_params))
    @n.save!
    redirect_to "/notes/#{@n.id}"
  end

  def update
    n = Note.find(params[:id])
    existing_tag_ids = n.tag_ids
    n.update(create_tags(existing_tag_ids, note_params))
    redirect_to "/notes/#{n.id}"
  end

  def destroy
    Note.find(params[:id]).delete
    redirect_to '/courses'
  end

  def edit
    @note = Note.find(params[:id])
    @courses = Course.all
  end

  def show
    @note = Note.find(params[:id])
    @comments = Comment.where(:note_id => @note.id, :parent_id => nil)
    @comment = Comment.new
    @user = @current_user
  end

  private

  def note_params
    params.require(:note).permit(:title, :content, :user_id, :course_id, :tag_ids)
  end

end
