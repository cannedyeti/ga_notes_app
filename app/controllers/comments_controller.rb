class CommentsController < ApplicationController
  def create
    if @current_user
      @c = Comment.new(comment_params)
      @c.save!
      if @c.parent_id == nil
        redirect_to '/notes/' + comment_params[:note_id] + "#comment_" + @c.id.to_s
      else
        redirect_to '/notes/' + comment_params[:note_id] + "#comment_" + @c.parent_id.to_s
      end
    else
      flash[:warning] = "You need to log in to post a comment"
      redirect_to login_path
    end
  end

  def add_points(beforePoints, afterPoints, user_id)
    u = User.find(user_id)
    points = u.points || 0
    points -= beforePoints
    points += afterPoints
    u.update(points: points)
  end

  def vote
    n = Comment.find(params[:id])
    note = Note.find(n.note_id)
    if note.whitelist.length != 1
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

        if n.parent_id == nil
          redirect_to '/notes/' + n.note_id.to_s + "#comment_" + n.id.to_s
        else
          redirect_to '/notes/' + n.note_id.to_s + "#comment_" + n.parent_id.to_s
        end
      end
    end
  end


  def destroy
    #delete all replies too
    @c = Comment.find(params[:id])
    @c.child_comments.destroy_all
    note_id = @c.note.id
    parent_id = @c.parent_id
    @c.delete
    if parent_id == nil
      redirect_to '/notes/' + note_id.to_s
    else
      redirect_to '/notes/' + note_id.to_s + "#comment_" + parent_id.to_s
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:content, :user_id, :note_id, :parent_id)
  end
end
