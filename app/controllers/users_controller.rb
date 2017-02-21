class UsersController < ApplicationController

  def index
    @users = User.all
  end


  private

  def avatar_params
    params.require(:user).permit(:name, :avatar)
  end

end
