class BookingsController < ApplicationController
  before_action :set_booking, except: [:index, :new, :user_confirmed, :client_confirmed]
  def index
    @bookings = Booking.all
  end

  def show
  end

  def new
    @booking = Booking.new
  end

  def edit
  end

  def create
    @booking = @request.bookings.build(booking_params)
    if @booking.save
      puts "Hurray"
    else
      puts "GODDAMNIT!"
    end
  end

  def update
    @booking.update(booking_params)
    redirect_to :back
  end

  def user_confirmed
    @booking = Booking.find(params[:booking_id])
    @booking.update(booking_params)
    redirect_to :back
  end

  def client_confirmed
    @booking = Booking.find(params[:booking_id])
    @booking.update(booking_params)
    redirect_to :back
  end

  def destroy
    @booking.destroy
  end

  private

  def booking_params
    params.require(:booking).permit(:user_id, :start_time, :end_time, :location,
      :client_id, :paid, :price_cents, :user_confirmed)
  end

  def set_booking
    @booking = Booking.find(params[:id])
  end
end
