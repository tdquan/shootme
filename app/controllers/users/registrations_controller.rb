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
    build_resource(sign_up_params)
    resource.save
    resource.wallet = Wallet.create!
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  def update
    unless params[:user][:album][:name].empty? || params[:user][:album][:photos].empty?
      @album = current_user.albums.create(name: params[:user][:album][:name], photos: params[:user][:album][:photos])
    else
      @album = current_user.albums.new
    end
    super
  end

  def delete
    super
  end
end
