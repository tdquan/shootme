class Users::RegistrationsController < Devise::RegistrationsController
  def show
    @current_user = current_user
    @request = Request.new
    @cities = ["Paris", "London"]
    @current_profile = User.find(params[:user_id])

    if @current_profile.role
      @roles = @current_profile.role.split(" - ").sort
    else
      @roles = []
    end
    # Chat
    # unless params[:user_id].to_i == current_user.id
    #   if Conversation.between(params[:user_id],current_user.id).present?
    #     @conversation = Conversation.between(params[:user_id], current_user.id).first
    #   elsif Conversation.between(current_user.id, params[:user_id]).present?
    #     @conversation = Conversation.between(current_user.id, params[:user_id]).first
    #   else
    #     @conversation = Conversation.create!(user_id: params[:user_id], client_id: current_user.id)
    #   end
    # end
  end

  def new
    super
    @role = ["Photographer", "Videographer", "Drone Pilot"]
  end

  def edit
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
