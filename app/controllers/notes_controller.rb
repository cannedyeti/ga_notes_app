class NotesController < ApplicationController
  def index
    @notes = Note.where(:user_id => @current_user.id)
    @notes = @notes.paginate(:page => params[:page], :per_page => 10)
    @notes.each do |n|
      n.content = Sanitize.clean(n.content)
      n.content = n.content[0..200] + '...'
    end
  end

  def new
    if @current_user
      @note = Note.new
      @courses = Course.all
    else 
      redirect_to "/"
      flash[:warning] = "You must be logged in to post."
    end
  end


  def make_private
    n = Note.find(params[:id])
    if @current_user.id == n.user.id
      n.update(:whitelist => [@current_user.id.to_s])
      redirect_to '/notes'
    else 
      redirect_to "/notes"
      flash[:warning] = "You do not have the privilege for this."
    end
  end

  def publish
    n = Note.find(params[:id])
    if @current_user.id == n.user.id
      n.update(:whitelist => [])
      redirect_to '/notes'
    else
      redirect_to "/notes"
      flash[:warning] = "You do not have the privilege for this."
    end
  end

# does not need route protection
  def add_points(beforePoints, afterPoints, user_id)
    u = User.find(user_id)
    points = u.points || 0
    points -= beforePoints
    points += afterPoints
    u.update(points: points)
  end

  def vote
    n = Note.find(params[:id])
    #don't let user vote if they're not logged in
    if @current_user
      #don't let user vote if the note is private
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
    else
      flash[:warning] = "You need to sign in or sign up to like/dislike."
    end
  end

  def create_whitelist(existing_whitelist, note_params)
    whitelist = existing_whitelist || []
    # whitelist.concat existing_whitelist
    note_params[:whitelist] = whitelist.push(@current_user.id)
    return note_params
  end

  # def add_to_white_list
  #   n = Note.find(params[:id])
  #   existing_whitelist = n.whitelist
  #   # !!!!!!!! FIX THIS CURRENT USER PUSH TO THE ENTERED USER
  #   # existing_whitelist.push(@current_user.id.to_s)
  #   # !!!!!!!!!
  #   temp_param = note_params
  #   temp_param[:whitelist] = existing_whitelist
  #   n.update(temp_param)
  #   redirect_to '/notes'
  # end

  def create_tags(existing_tag_ids, note_params)
    tag_names = note_params[:tag_ids].downcase
    tag_ids = []
    tag_ids.concat existing_tag_ids
    tag_names.split(/\s*,\s*/).each do |tn|
      new_tag = Tag.find_or_create_by(tag_name: tn)
      tag_ids.push(new_tag.id)
    end
    # existing_whitelist = note_params[:whitelist]
    # create_whitelist(existing_whitelist, note_params)
    note_params[:tag_ids] = tag_ids
    return note_params
  end

  def create
    if @current_user
      #create the post
      whitelist = []
      note_params[:whitelist] = whitelist.push(@current_user.id)
      create_whitelist([], create_tags([], note_params))
      @n = Note.new(create_whitelist([], create_tags([], note_params)))
      @n.save!
      redirect_to "/notes/#{@n.id}"
    else
      redirect_to "/notes"
      flash[:warning] = "You must be logged in to create a note."
    end
  end

  def update
    n = Note.find(params[:id])
    if @current_user && (@current_user.id == n.user.id)
      existing_tag_ids = n.tag_ids
      n.update(create_tags(existing_tag_ids, note_params))
      redirect_to "/notes/#{n.id}"
    else
      redirect_to "/notes/#{n.id}"
      flash[:warning] = "Only the note creator can edit a note."
    end
  end


# DOUBLE CHECK DELETION LOGIC - looks good.
  def destroy
    n = Note.find(params[:id])
    if (@current_user.id == n.user.id) || (@current_user.privilege == 2)
      NotesTags.where(:note_id => params[:id]).destroy_all
      c = Comment.where(:note_id => params[:id])
      c.each do |child|
        child.child_comments.destroy_all
      end
      c.destroy_all
      n.delete
      puts "request.referer" + request.referer
      redirect_to '/courses'
    else
      redirect_to '/notes' 
      flash[:danger] = "You cannot delete this note."
    end
  end

  def edit
    @note = Note.find(params[:id])
    if @current_user && (@current_user.id == @note.user.id)
      @courses = Course.all
    else
      redirect_to "/notes/#{@note.id}"
      flash[:warning] = "Only the note creator can edit a note."
    end
  end

  def show
    @note = Note.find(params[:id])
    @comments = Comment.where(:note_id => @note.id, :parent_id => nil).order(created_at: :desc)
    @comment = Comment.new
    if @current_user
      @user = @current_user
      @favorite_ids = []
      @current_user.favorites.each do |f|
        @favorite_ids.push(f.note_id)
      end
    end
  end

  private

  def note_params
    params.require(:note).permit(:title, :content, :user_id, :course_id, :tag_ids, :whitelist)
  end
end
