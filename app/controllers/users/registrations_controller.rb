class Users::RegistrationsController < Devise::RegistrationsController

  def show
    super
    @user = User.find(params[user_id: current_user.id])
    @booking = Booking.new
  end
end
