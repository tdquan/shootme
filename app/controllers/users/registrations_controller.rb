class Users::RegistrationsController < Devise::RegistrationsController
  def show
    @current_user = current_user
    @request = Request.new
    @cities = ["Paris", "London"]
    @current_profile = User.find(params[:user_id])
    @requests = Request.where(user: @current_profile)
    @review = Review.new
    @bookings_to_others = []
    Booking.all.each do |booking|
      @bookings_to_others << booking if booking.request.client_id == current_user.id
    end

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
    @role = ["Photographer", "Videographer", "Drone Pilot"]
    super
  end

  def create
    super
  end

  def update
    unless params[:user][:album][:name].empty? || params[:user][:album][:photos].empty?
      @album = current_user.albums.create(name: params[:user][:album][:name], photos: params[:user][:album][:photos])
    end
    super
  end

  def delete
    super
  end
end
