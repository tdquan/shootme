class Users::RegistrationsController < Devise::RegistrationsController

  def search
    @users = User.near(params["user"]["address"], 20)
    set_hash(@users)
    render :index
  end


  def set_hash(users)
    @hash = Gmaps4rails.build_markers(@users) do |user, marker|
      marker.lat user.latitude
      marker.lng user.longitude
      # marker.infowindow render_to_string(partial: "/users/map_box", locals: { user: user })
    end
  end

end
