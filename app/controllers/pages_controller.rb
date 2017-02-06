class PagesController < ApplicationController
  def home
    @user = User.new
    @users = User.all
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
end
