class MessagesController < ApplicationController
  before_action :set_conversation
  before_action :set_messages, only: [:index, :create, :refresh_chat]

  def index
    @user = @conversation.user
    if @messages.last
      @messages.each do |m|
        if m.user_id != current_user.id
          m.read = true
          m.save
        end
      end
    end
    @message = @conversation.messages.new
  end

  def new
    @message = @conversation.messages.new
  end

  def create
    @message = @conversation.messages.new(message_params)
    if @message.save
      respond_to do |format|
        format.js
      end
    end
  end

  def refresh_chat
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

  def set_messages
    @messages = @conversation.messages
    if @messages.length > 10
      @over_ten = true
      @messages = @messages.last(10)
    end
    if params[:m]
      @over_ten = false
      @messages = @conversation.messages
    end
  end

end
