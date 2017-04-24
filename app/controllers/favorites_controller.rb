class FavoritesController < ApplicationController
  def index
    if @current_user
      @user = @current_user
      @favorites = []
      @favorite_ids = []
      @current_user.favorites.each do |f|
        @favorites.push(Note.find(f.note_id))
      end
      @favorites.each do |n|
        n.content = Sanitize.clean(n.content)
        n.content = n.content[0..100] + '...'
      end
    else
      redirect_to "/"
      flash[:warning] = "Please log in before doing that."
    end
  end

  def create
    if @current_user
      @user = @current_user
      f = Favorite.new(favorite_params)
      f.save!
      redirect_to '/favorites'
    else
      redirect_to "/"
      flash[:warning] = "Please log in before doing that."
    end
  end

  def destroy
    if @current_user
      Favorite.where(:user_id => @current_user.id, :note_id => params[:id]).first.delete
      redirect_to :back
    else
      redirect_to "/"
      flash[:warning] = "Please log in before doing that."
    end
  end

  private

  def favorite_params
    params.require(:favorite).permit(:user_id, :note_id)
  end
end
