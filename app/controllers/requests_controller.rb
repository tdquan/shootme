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
    end
    if @request.save
      HomePageMailer.creation_confirmation(@request).deliver_now
    else
      puts "GODDAMNIT!"
    end
    redirect_to :back
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
end
