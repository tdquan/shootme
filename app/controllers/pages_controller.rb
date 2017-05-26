class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :landing_page]
  def home
    @cities = ["Paris", "Marseille", "Lyon", "Toulouse", "Nice", "Nantes"]

    # geocoding
    @users_marker = User.where.not(latitude: nil, longitude: nil)
    # @hash = set_map_hash(@users_marker)
    @hash = Gmaps4rails.build_markers(@users_marker) do |user, marker|
      marker.lat user.latitude
      marker.lng user.longitude
      marker.infowindow render_to_string(partial: "/users/map_box", locals: { user: user })
      if user.role == "Drone Pilot"
        marker.picture({
          url: view_context.image_path("pin_yellow.png"),
          width: 32,
          height: 57
        })
      elsif user.role == "Videographer"
        marker.picture({
          url: view_context.image_path("pin_green.png"),
          width: 32,
          height: 57
        })
      else
        marker.picture({
          url: view_context.image_path("pin_red.png"),
          width: 32,
          height: 57
        })
      end
    end
  end

  def landing_page
    @cities = ["Paris", "Marseille", "Lyon", "Toulouse", "Nice", "Nantes"]
    @user = User.new
  end

  def payment
    @user = User.find(params[:user_id])
    @booking = Booking.find(params[:booking])
    @amount = @booking.price_cents
  end

  def contact_mailer
    user = User.new(first_name: params[:mailer][:name], email: params[:mailer][:email])
    message = params[:mailer][:message]
    HomePageMailer.contact_mailer(user, message).deliver_now
    redirect_to :root
  end

end
