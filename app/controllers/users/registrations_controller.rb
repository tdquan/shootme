class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :set_minimum_password_length, only: [:new, :new_pro_user, :edit]
  skip_before_action :authenticate_user!, only: [:new, :create]
  def show
    if can? :read, User
      @current_user = current_user
      @request = Request.new
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
    else
      redirect_to new_user_session_path
    end
  end

  def edit
    @album = current_user.albums.new
    super
  end

  def new
    super
  end

  def new_pro_user
    build_resource({})
    @roles = ["Photographer", "Videographer", "Drone Pilot"]
    yield resource if block_given?
    respond_with resource
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
        respond_with resource, location: home_path
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

  def create_pro
    build_resource(sign_up_params)

    # STRIPE
    Stripe.api_key = "sk_test_RDQ2OvHT5avxYmei7AeplbDG"
    token = params[:stripeToken]

    # Create a Customer:
    customer = Stripe::Customer.create(
      :email => resource[:email],
      :source => token,
    )
    resource.stripe_id = customer.id
    resource.save

    resource.wallet = Wallet.create!
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        redirect_to home_path
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      render :new_pro_user
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
