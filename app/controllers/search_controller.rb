class SearchController < ApplicationController
  def search
    if params["user"]["email"].nil?
      @users = []
    else
      @users = User.search params["user"]["email"]
    end

    respond_to do |f|
      f.html
      f.js
    end
  end

end

