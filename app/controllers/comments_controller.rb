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

  def vote()
    isDown = (params[:isDown] == 'true')
    n = Comment.find(params[:id])
    dv = []
    uv = []
    if isDown
      dv = n.down_votes
      uv = n.up_votes
    else
      dv = n.up_votes
      uv = n.down_votes
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
      n.update(up_votes: uv, down_votes: dv)
    else
      n.update(up_votes: dv, down_votes: uv)
    end

    if n.parent_id == nil
      redirect_to '/notes/' + n.note_id.to_s + "#comment_" + n.id.to_s
    else
      redirect_to '/notes/' + n.note_id.to_s + "#comment_" + n.parent_id.to_s
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
