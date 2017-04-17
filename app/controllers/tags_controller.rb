class TagsController < ApplicationController
  def index
  end

  def new
  end

  def create
  end

  def show
  end

  private

  def tag_params
    params.require(:tag).permit(:tag_name, :note_ids => [])
  end

end
