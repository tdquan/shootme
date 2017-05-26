# require 'elasticsearch/dsl'

class SearchController < ApplicationController
  skip_before_action :authenticate_user!
  def search
    # Search filtering
    if params[:user][:q].blank? && params[:user][:location].blank? && params[:user][:profession].count <= 1
      @users = User.where(pro: true)
    elsif params[:user][:q].present? && params[:user][:location].present? && params[:user][:profession].count > 1
      @users = User.query_search(params[:user][:q])
      @users = @users.select { |user| (user.city && user.city.include?(params[:user][:location])) }
      @users = @users.select { |user| !(user.role.split(" - ") & params[:user][:profession]).empty? }
      @users = @users.select { |user| user.pro == true }
    elsif params[:user][:q].present? && params[:user][:location].blank? && params[:user][:profession].count <= 1
      @users = User.query_search(params[:user][:q])
      @users = @users.select { |user| user.pro == true }
    elsif params[:user][:q].present? && params[:user][:location].present? && params[:user][:profession].count <= 1
      @users = User.query_search(params[:user][:q])
      @users = @users.select { |user| (user.city && user.city.include?(params[:user][:location])) }
      @users = @users.select { |user| user.pro == true }
    elsif params[:user][:q].present? && params[:user][:location].blank? && params[:user][:profession].count > 1
      @users = User.query_search(params[:user][:q])
      @users = @users.select { |user| !(user.role.split(" - ") & params[:user][:profession]).empty? }
      @users = @users.select { |user| user.pro == true }
    elsif params[:user][:q].blank? && params[:user][:location].present? && params[:user][:profession].count <= 1
      @users = User.search_by_location(params[:user][:location])
      @users = @users.select { |user| user.pro == true }
    elsif params[:user][:q].blank? && params[:user][:location].present? && params[:user][:profession].count > 1
      @users = User.search_by_location(params[:user][:location])
      @users = @users.select { |user| !(user.role.split(" - ") & params[:user][:profession]).empty? }
      @users = @users.select { |user| user.pro == true }
    elsif params[:user][:q].blank? && params[:user][:location].blank? && params[:user][:profession].count > 1
      @users = User.search_by_profession(params[:user][:profession].join(" "))
      @users = @users.select { |user| user.pro == true }
    end

    # Get user with location
    @user_markers = []
    @users.each do |user|
      if user.latitude != nil && user.longitude != nil
        @user_markers << user
      end
    end

    @hash = Gmaps4rails.build_markers(@user_markers) do |user, marker|
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

    respond_to do |f|
      f.html
      f.js
    end
  end

end

