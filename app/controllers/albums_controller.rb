class AlbumsController < ApplicationController
  def index
  end

  def show
  end

  private

  def album_params
    params.require(:album).permit(:name, :description, photos: [])
  end

end
