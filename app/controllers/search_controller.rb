require 'elasticsearch/dsl'

class SearchController < ApplicationController
  def search
    if params[:user][:q].nil?
      @users = []
    else
      term = params[:user][:q]
      location = params[:user][:location]

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
            should do
              multi_match do
                query location
                type "most_fields"
                fields ["address"]
              end
            end
          end
        end

      end

      @users = User.search query
    end

    respond_to do |f|
      f.html
      f.js
    end
  end

end

