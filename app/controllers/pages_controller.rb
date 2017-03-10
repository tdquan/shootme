class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:landing_page]
  def home
    @cities = ["Paris", "Marseille", "Lyon", "Toulouse", "Nice", "Nantes"]
    @users_marker = User.where.not(latitude: nil, longitude: nil)
    # @hash = set_map_hash(@users_marker)
    @hash = Gmaps4rails.build_markers(@users_marker) do |user, marker|
      marker.lat user.latitude
      marker.lng user.longitude
      marker.infowindow render_to_string(partial: "/users/map_box", locals: { user: user })
    end
  end

  def landing_page
    @cities = ["Paris", "Marseille", "Lyon", "Toulouse", "Nice", "Nantes"]
  end

  def search
    if params["/search"]["email"].nil?
      @users = []
    else
      @users = User.search params["/search"]["email"]
    end

    respond_to do |f|
      f.html
      f.js
    end
  end

  def payment
    @user = User.new
  end

  private

  # def set_map_hash(users)
  #   map_hash = []
  #   users.where.not(latitude: nil, longitude: nil).each do |user|
  #     map_hash << {
  #       lat: user.latitude,
  #       lng: user.longitude,
  #       label: user.first_name,
  #       picture: user.avatar
  #       infowindow: render_to_string(partial: "/users/map_box", locals: { user: user })
  #     }
  #   end
  #   map_hash
  # end
end
