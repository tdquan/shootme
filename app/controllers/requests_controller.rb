class RequestsController < ApplicationController
  before_action :set_request, only: [:show, :edit, :update, :destroy]
  def index
    @requests = Request.all
  end

  def show
  end

  def new
    @request = Request.new
  end

  def edit
  end

  def create
    @current_profile = User.find(params[:user_id])
    if @current_profile.fee_cents && @current_profile.fee_cents > 0
      @request = current_user.requests_to_others.build(request_params)
      @request.price_cents = @current_profile.fee_cents
      if @request.save
        HomePageMailer.creation_confirmation(@request).deliver_now
        flash[:success] = "Request sent!"
        set_profile
        render template: 'devise/registrations/show', locals: {request: @request}
      end
    else
      flash[:error] = "Error. Cannot create appointment. Please contact user for more information."
      set_profile
      render template: 'devise/registrations/show', locals: {request: @request}
    end
  end

  def update
    @request.update(request_params)
    if @request.confirmed == true
      HomePageMailer.request_confirmation(@request).deliver_now
      @booking = Booking.create(request_id: @request.id, location: @request.location,
        start_time: @request.start_time, end_time: @request.end_time, price_cents: @request.price_cents)
      HomePageMailer.booking_confirmation(@booking).deliver_now
    end
  end

  def destroy
    @request.destroy
    redirect_to :back, notice: 'Request was successfully deleted.'
  end

  private

  def request_params
    params.require(:request).permit(:user_id, :client_id, :start_time, :end_time,
      :location, :confirmed)
  end

  def set_request
    @request = Request.find(params[:id])
  end

  def set_profile
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
  end
end
