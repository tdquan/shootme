class RequestsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy]
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
  end

  def destroy
    @request.destroy
  end

  private

  def request_params
    params.require(:request).permit(:user_id, :client_id, :start_time, :end_time, :location)
  end

  def set_request
    @request = Request.find(params[:id])
  end
end
