class Users::RegistrationsController < Devise::RegistrationsController
  def show
    @current_user = current_user
    @request = Request.new
    @cities = ["Paris", "London"]
    @current_profile = User.find(params[:user_id])
    if @current_profile.role
      @roles = @current_profile.role.split(" - ").sort
    else
      @roles = []
    end
  end

  def edit
    @album = current_user.albums.new
    super
  end

  def new
    super
    @role = ["Photographer", "Videographer", "Drone Pilot"]
  end

  def create
    super
  end

  def update
    @album = current_user.albums.create(name: params[:user][:album][:name], photos: params[:user][:album][:photos])
    super
  end

  def delete
    super
  end
end
