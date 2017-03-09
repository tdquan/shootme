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
    @request = current_user.requests_to_others.build(request_params)
    if @request.save
      puts "Hurray"
    else
      puts "GODDAMNIT!"
    end
    redirect_to :back
  end

  def update
    @request.update(request_params)
    if @request.confirmed == true
      @booking = Booking.create(request_id: @request.id, location: @request.location,
        start_time: @request.start_time, end_time: @request.end_time, price: @request.price)
    end
  end

  def destroy
    @request.destroy
    redirect_to :back, notice: 'Request was successfully deleted.'
  end

  private

  def request_params
    params.require(:request).permit(:user_id, :client_id, :start_time, :end_time,
      :location, :confirmed, :price)
  end

  def set_request
    @request = Request.find(params[:id])
  end
end
