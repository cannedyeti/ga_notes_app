class NotesController < ApplicationController
  def index
    @notes = Note.where(:user_id => @current_user.id)
  end

  def new
    @note = Note.new
    @courses = Course.all
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

  def add_points(beforePoints, afterPoints, user_id)
    u = User.find(user_id)
    points = u.points || 0
    points -= beforePoints
    points += afterPoints
    u.update(points: points)
  end

  def update_privillages(points, user)
    if points >= 50 && user.privilege == 0
      #make the user a moderator
      user.update(privilege: 1)
    elsif points < 50 && user.privilege == 1
      #make the user basic
      user.update(privilege: 0)
    end
  end

  def vote
    #don't let user vote if the note is private
    n = Note.find(params[:id])
    if n.whitelist.length != 1
      #don't let the user vote on their own note
      if n.user_id != @current_user.id
        isDown = (params[:isDown] == 'true')
        beforePoints = 0
        afterPoints = 0
        dv = []
        uv = []
        if isDown
          dv = n.down_votes
          uv = n.up_votes
          beforePoints = uv.length - dv.length
        else
          dv = n.up_votes
          uv = n.down_votes
          beforePoints = dv.length - uv.length
        end

        if !(dv.include?(@current_user.id.to_s))
          dv.push(@current_user.id.to_s)
        else
          dv.delete(@current_user.id.to_s)
        end

        if uv.include?(@current_user.id.to_s)
          uv.delete(@current_user.id.to_s)
        end

        if isDown
          afterPoints = uv.length - dv.length
          n.update(up_votes: uv, down_votes: dv)
        else
          afterPoints = dv.length - uv.length
          n.update(up_votes: dv, down_votes: uv)
        end

        add_points(beforePoints, afterPoints, n.user_id)

        redirect_to :back
      end
    end
  end

  def create_whitelist(existing_whitelist, note_params)
    whitelist = existing_whitelist || []
    # whitelist.concat existing_whitelist
    note_params[:whitelist] = whitelist.push(@current_user.id)
    return note_params
  end

  def add_to_white_list
    n = Note.find(params[:id])
    existing_whitelist = n.whitelist
    # !!!!!!!! FIX THIS CURRENT USER PUSH TO THE ENTERED USER
    existing_whitelist.push(@current_user.id.to_s)
    # !!!!!!!!!
    temp_param = note_params
    temp_param[:whitelist] = existing_whitelist
    n.update(temp_param)
    redirect_to '/notes'
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
    puts "request.referer" + request.referer
    redirect_to '/courses'
  end

  def edit
    @note = Note.find(params[:id])
    @courses = Course.all
  end

  def show
    @note = Note.find(params[:id])
    @comments = Comment.where(:note_id => @note.id, :parent_id => nil).order(created_at: :desc)
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
