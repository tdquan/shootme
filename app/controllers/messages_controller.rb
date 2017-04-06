class MessagesController < ApplicationController
  before_action do
    @conversation = Conversation.find(params[:conversation_id])
  end

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
      respond_to do |f|
        f.js
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:body, :user_id)
  end

end
