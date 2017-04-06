class AlbumsController < ApplicationController
  before_action :set_user

  def index
    @albums = @current_profile.albums.all
  end

  def show
  end

  def create
  end

  def render_gallery
    respond_to do |format|
      format.js
    end
  end

  private

  def album_params
    params.require(:album).permit(:name, :description, photos: [])
  end

  def set_user
    @current_profile = User.find(params[:user_id])
  end

end
