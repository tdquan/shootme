require 'elasticsearch/dsl'

class SearchController < ApplicationController
  def search
    @users = []
    if params[:user][:q].blank? && params[:user][:location].blank?
      @users = User.all
    else

    end

    respond_to do |f|
      f.html
      f.js
    end
  end

end

