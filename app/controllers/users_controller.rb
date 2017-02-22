class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def inbox
    # @bookings = current_user.bookings
    # @requests = current_user.requests
    @requests_to_self = current_user.requests_to_self
    @requests_to_others = current_user.requests_to_others
    # @conversations = current_user.conversations
  end

  private

  def avatar_params
    params.require(:user).permit(:name, :avatar)
  end
end
