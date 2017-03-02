require 'elasticsearch/dsl'

class SearchController < ApplicationController
  def search
    if params[:user][:q].nil? && params[:user][:location].nil?
      @users = []
    else
      term = params[:user][:q]
      location = params[:user][:location]
      profession = params[:user][:profession]
      distance = params[:user][:distance]

      query = Elasticsearch::DSL::Search.search do
        query do
          bool do
            should do
              multi_match do
                query term
                type "most_fields"
                fields ["email", "first_name", "last_name"]
                operator "or"
              end
            end
            filter :terms, :address, location
          end
        end

      end

      @users = User.search(query)
      puts @users.first
    end

    respond_to do |f|
      f.html
      f.js
    end
  end

end

