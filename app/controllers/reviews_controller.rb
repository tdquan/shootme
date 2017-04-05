class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_action :set_booking, only: [:new, :create, :edit, :update]

  def index
    @reviews = Review.all
  end

  def show
  end

  def new
    @review = Review.new
  end

  def edit
  end

  def create
    @review = Review.new(review_params)
    @review.booking = @booking
    if @review.save
      puts 'review saved'
    else
      puts 'review not saved'
    end
  end

  def update
    @review.update(review_params)
  end

  def destroy
    @review.destroy
  end

private
  def review_params
    params.require(:review).permit(:booking_id, :comment, :rating)
  end

  def set_review
    @review = Review.find(params[:id])
  end

  def set_booking
    @booking = Booking.find(params[:booking_id])
  end
end
