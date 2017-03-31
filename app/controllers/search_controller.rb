# require 'elasticsearch/dsl'

class SearchController < ApplicationController
  def search
    @users = []
    if params[:user][:q].blank? && params[:user][:location].blank? && params[:user][:profession].count <= 1
      @users = User.all
    elsif params[:user][:q].present? && params[:user][:location].present? && params[:user][:profession].count > 1
      @users = User.query_search(params[:user][:q])
      @users = @users.select { |user| (user.address && user.address.include?(params[:user][:location])) }
      @users = @users.select { |user| !(user.role.split(" - ") & params[:user][:profession]).empty? }
    elsif params[:user][:q].present? && params[:user][:location].blank? && params[:user][:profession].count <= 1
      @users = User.query_search(params[:user][:q])
    elsif params[:user][:q].present? && params[:user][:location].present? && params[:user][:profession].count <= 1
      @users = User.query_search(params[:user][:q])
      @users = @users.select { |user| (user.address && user.address.include?(params[:user][:location])) }
    elsif params[:user][:q].present? && params[:user][:location].blank? && params[:user][:profession].count > 1
      @users = User.query_search(params[:user][:q])
      @users = @users.select { |user| !(user.role.split(" - ") & params[:user][:profession]).empty? }
    elsif params[:user][:q].blank? && params[:user][:location].present? && params[:user][:profession].count <= 1
      @users = User.search_by_location(params[:user][:location])
    elsif params[:user][:q].blank? && params[:user][:location].present? && params[:user][:profession].count > 1
      @users = User.search_by_location(params[:user][:location])
      @users = @users.select { |user| !(user.role.split(" - ") & params[:user][:profession]).empty? }
    elsif params[:user][:q].blank? && params[:user][:location].blank? && params[:user][:profession].count > 1
      @users = User.search_by_profession(params[:user][:profession].join(" "))
    end

    respond_to do |f|
      f.html
      f.js
    end
  end

end

