class AlbumsController < ApplicationController
  before_action :set_user
  skip_before_filter  :verify_authenticity_token, only: :add_photo

  def index
    @albums = @current_profile.albums.all
  end

  def show
  end

  def create
  end

  def render_gallery
    @current_album = Album.find(params[:album_id])
    @album = Album.new
    respond_to do |format|
      format.js
    end
  end

  def all_galleries
    @albums = @current_profile.albums.all
    respond_to do |format|
      format.js
    end
  end

  def add_photo
    @current_album = Album.find(params[:album_id])
    @album = Album.new(photos: params[:album][:photos])
    @album.photos.each do |photo|
      @current_album.photos << photo
    end
    respond_to do |format|
      format.js
    end
  end

  def delete_photo
    @public_id = params[:public_id]
    Album.find(params[:album_id]).photos.find_by_public_id(@public_id).destroy
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
