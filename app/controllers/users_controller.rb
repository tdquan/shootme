class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def inbox
    @conversations = Conversation.all
    # @bookings = current_user.bookings
    @requests_to_self = current_user.requests_to_self
    @requests_to_others = current_user.requests_to_others
    # @conversations_client = Conversation.find_by client_id: current_user.id
    # @conversations_user = Conversation.find_by user_id: current_user.id
    # @messages_user = @conversations_user.messages
    # @messages_client = @conversations_client.messages
  end

  private

  def avatar_params
    params.require(:user).permit(:name, :avatar)
  end
end


# request to others:
# request client is the current user
# request user is the photographer
