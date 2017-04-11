class MessagesController < ApplicationController
  before_action :set_conversation

  def index
    @user = @conversation.user
    @messages = @conversation.messages
    if @messages.length > 10
      @over_ten = true
      @messages = @messages[-10..-1]
    end
    if params[:m]
      @over_ten = false
      @messages = @conversation.messages
    end
    if @messages.last
      if @messages.last.user_id != current_user.id
        @messages.last.read = true;
      end
    end
    @message = @conversation.messages.new
  end

  def new
    @message = @conversation.messages.new
  end

  def create
    @messages = @conversation.messages
    @message = @conversation.messages.new(message_params)
    if @message.save
      respond_to do |format|
        format.js {render action: "refresh_chat.js.erb"}
      end
    end
  end

  def refresh_chat
    @messages = @conversation.messages
    respond_to do |format|
      format.js
    end
  end

  private

  def message_params
    params.require(:message).permit(:body, :user_id)
  end

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

end
