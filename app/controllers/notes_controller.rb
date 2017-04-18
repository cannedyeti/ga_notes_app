class NotesController < ApplicationController
  def index
    @notes = Note.where(:user_id => @current_user.id)
  end

  def new
    @note = Note.new
    @courses = Course.all
  end

  def create_whitelist(existing_whitelist, note_params)
    whitelist = existing_whitelist || []
    note_params[:whitelist] = whitelist.push(@current_user.id)
    return note_params
  end

  def make_private
    n = Note.find(params[:id])
    n.update(:whitelist => [@current_user.id.to_s])
    redirect_to '/notes'
  end

  def publish
    n = Note.find(params[:id])
    n.update(:whitelist => [])
    redirect_to '/notes'
  end

  def add_to_white_list
    n = Note.find(params[:id])
    existing_whitelist = n.whitelist
    n.update(create_whitelist, note_params)
  end

  def create_tags(existing_tag_ids, note_params)
    tag_names = note_params[:tag_ids]
    tag_ids = []
    tag_ids.concat existing_tag_ids
    tag_names.split(/\s*,\s*/).each do |tn|
      new_tag = Tag.find_or_create_by(tag_name: tn)
      tag_ids.push(new_tag.id)
    end
    existing_whitelist = note_params[:whitelist]
    create_whitelist(existing_whitelist, note_params)
    note_params[:tag_ids] = tag_ids
    return note_params
  end

  def create
    #create the post
    whitelist = []
    note_params[:whitelist] = whitelist.push(@current_user.id)
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
    NotesTags.where(:note_id => params[:id]).destroy_all
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
    @favorite_ids = []
    @current_user.favorites.each do |f|
      @favorite_ids.push(f.note_id)
    end
  end

  private

  def note_params
    params.require(:note).permit(:title, :content, :user_id, :course_id, :tag_ids, :whitelist)
  end

end
