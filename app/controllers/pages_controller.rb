class PagesController < ApplicationController
  def home
    @cities = ["Paris", "Marseille", "Lyon", "Toulouse", "Nice", "Nantes"]
  end
end
