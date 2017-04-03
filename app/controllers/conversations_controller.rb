class ConversationsController < ApplicationController
  # before_action :authenticate_user

  def index
    @users = User.all
    @conversations = Conversation.all
  end

  def create
    unless params[:user_id].to_i == current_user.id
      if Conversation.between(params[:user_id],current_user.id).present?
        @conversation = Conversation.between(params[:user_id], current_user.id).first
      elsif Conversation.between(current_user.id, params[:user_id]).present?
        @conversation = Conversation.between(current_user.id, params[:user_id]).first
      else
        @conversation = Conversation.create!(user_id: params[:user_id], client_id: current_user.id)
      end
    end

    redirect_to user_conversation_messages_path(@conversation, conversation_id: @conversation.id)
  end

  # def conversations
  #   @conversations = Conversation.find_by client_id: current_user.id
  # end

  private

  def conversation_params
    params.permit(:user_id, :client_id)
  end
end
