class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def inbox
    # messages
    @conversations = Conversation.all

    # request to others:
    # request client is the current user
    # request user is the pro
    @requests_to_self = current_user.requests_to_self
    @requests_to_others = current_user.requests_to_others

    # bookings
    @bookings_to_others = []
    @bookings_to_self = []
    Booking.all.each do |booking|
      @bookings_to_others << booking if booking.request.client_id == current_user.id
      @bookings_to_self << booking if booking.request.user_id == current_user.id
    end
    @review = Review.new
  end
end

