class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:landing_page]
  def home
    @cities = ["Paris", "Marseille", "Lyon", "Toulouse", "Nice", "Nantes"]
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
end
