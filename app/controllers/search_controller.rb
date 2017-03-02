require 'elasticsearch/dsl'

class SearchController < ApplicationController
  def search
    @users = []
    if params[:user][:q].blank? && params[:user][:location].blank?
      @users = User.all
    else
      term = params[:user][:q]
      location = params[:user][:location]
      profession = params[:user][:profession]
      distance = params[:user][:distance]

      query = Elasticsearch::DSL::Search.search do
        query do
          bool do
            # General query string search
            if !term.blank?
              must do
                multi_match do
                  query term
                  type "most_fields"
                  fields ["email", "first_name", "last_name"]
                  operator "or"
                end
              end
            end

            # Search by address
            if !location.blank?
              should do
                multi_match do
                  query location
                  type "most_fields"
                  fields ["address"]
                  operator "or"
                end
              end
            end

            # Search by profession
            if !profession.blank?
              should do
                multi_match do
                  query location
                  type "most_fields"
                  fields ["profession"]
                  operator "or"
                end
              end
            end

          end
        end
      end

      results = User.search(query)
      results.each do |user|
        if user.address == location
          @users << user
        end
      end
    end

    respond_to do |f|
      f.html
      f.js
    end
  end

end

