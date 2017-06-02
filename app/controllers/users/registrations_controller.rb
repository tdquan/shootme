class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :set_minimum_password_length, only: [:new, :new_pro_user, :edit]
  before_action :define_roles, only: [:edit, :update, :new_pro_user]
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
    @fee = current_user.fee_cents
    super
  end

  def new
    super
  end

  def new_pro_user
    build_resource({})
    yield resource if block_given?
    respond_with resource
  end

  def create
    build_resource(sign_up_params)
    resource.fee_cents = resource.fee_cents * 100
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
    Stripe.api_key = Rails.configuration.stripe[:secret_key]
    token = params[:stripeToken]

    # Create a Customer:
    customer = Stripe::Customer.create(
      :email => resource[:email],
      :source => token,
    )
    resource.stripe_id = customer.id
    resource.fee_cents = params[:user][:fee_cents].to_i * 100
    if params[:user][:role].count > 1
      resource.role = params[:user][:role].drop(1).join(" - ")
    end
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
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    # STRIPE
    unless resource.stripe_id
      Stripe.api_key = Rails.configuration.stripe[:secret_key]
      token = params[:stripeToken]

      # Create a Customer:
      if resource.stripe_id
        customer = Stripe::Customer.retrieve(resource.stripe_id)
        customer.sources.create(source: token)
      else
        customer = Stripe::Customer.create(
          :email => resource[:email],
          :source => token,
        )
        resource.stripe_id = customer.id
      end
    end

    resource.fee_cents = params[:user][:fee_cents].to_i * 100
    resource.role = params[:user][:role].drop(1).join(" - ")
    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      bypass_sign_in resource, scope: resource_name
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  def delete
    super
  end

  def define_roles
    @roles = [[:photographer, "Photographer"], [:videographer, "Videographer"], [:drone_pilot, "Drone Pilot"]]
  end
end
