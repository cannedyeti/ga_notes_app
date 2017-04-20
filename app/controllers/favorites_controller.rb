class FavoritesController < ApplicationController
  def index
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
  end

  def create
    @user = @current_user
    f = Favorite.new(favorite_params)
    f.save!
    redirect_to '/favorites'
  end

  def destroy
    Favorite.where(:user_id => @current_user.id, :note_id => params[:id]).first.delete
    redirect_to :back
  end

  private

  def favorite_params
    params.require(:favorite).permit(:user_id, :note_id)
  end
end
