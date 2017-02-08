class ConversationsController < ApplicationController
  # before_action :authenticate_user

  def index
    @users = User.all
    @conversations = Conversation.all
  end

  def create

    if Conversation.between(params[:user_id],params[:client_id])
     .present?
      @conversation = Conversation.between(params[:user_id],
       params[:client_id]).first
    else
      @conversation = Conversation.create!(conversation_params)
    end

    redirect_to user_conversation_messages_path(@conversation, conversation_id: @conversation.id)
  end

  private

  def conversation_params
    params.permit(:user_id, :client_id)
  end
end
