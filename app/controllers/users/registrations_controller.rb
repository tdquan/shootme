class Users::RegistrationsController < Devise::RegistrationsController
  def show
    @current_user = current_user
    @request = Request.new
    @cities = ["Paris", "London"]
    @current_profile = User.find(params[:user_id])
    unless @current_profile.role == nil
      @roles = @current_profile.role.split(" - ").sort
    end

    # Chat
    if Conversation.between(params[:user_id],current_user.id).present?
      @conversation = Conversation.between(params[:user_id], current_user.id).first
    elsif Conversation.between(current_user.id, params[:user_id]).present?
      @conversation = Conversation.between(current_user.id, params[:user_id]).first
    else
      @conversation = Conversation.create!(user_id: params[:user_id], client_id: current_user.id)
    end
  end

  def new
    super
    @role = ["Photographer", "Videographer", "Drone Pilot"]
  end

  def create
    super

  end

  def update
    super
  end

  def delete
    super
  end
end
