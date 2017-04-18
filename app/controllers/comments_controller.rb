class CommentsController < ApplicationController
  def create
    if @current_user
      @c = Comment.new(comment_params)
      @c.save!
      redirect_to "/notes/" + comment_params[:note_id]
    else
      flash[:warning] = "You need to log in to post a comment"
      redirect_to login_path
    end
  end

  def destroy
    #delete all replies too
    @c = Comment.find(params[:id])
    @c.child_comments.destroy_all
    note_id = @c.note.id
    @c.delete
    redirect_to "/notes/" + note_id.to_s
  end

  private
  def comment_params
    params.require(:comment).permit(:content, :user_id, :note_id, :parent_id)
  end
end
